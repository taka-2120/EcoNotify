//
//  IAPManager.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 8/13/24.
//

import Foundation
import StoreKit
import EcoNotifyEntity

@Observable @preconcurrency
public class IAPManager {
    private var purchasedProductIds = Set<String>()
    private var updates: Task<Void, Never>? = nil
    
    public var products = [Product]()
    public var isAdsRemoved: Bool {
        isPurchased(for: Constant.ProductId.removeAds.rawValue)
    }
    
    @MainActor public static let shared = IAPManager()
    
    private init() {
        updates = observeTransactionUpdates()
        Task {
            do {
                await updatePurchasedProducts()
                try await retrieveProducts()
            } catch {
                print(error)
            }
        }
    }

    deinit {
        updates?.cancel()
    }
    
    public func retrieveProducts() async throws {
        let productIds = Constant.ProductId.allCases.map { $0.rawValue }
        self.products = try await Product.products(for: productIds)
    }
    
    public func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try self.verifyPurchase(verification)
            await updatePurchasedProducts()
            await transaction.finish()
            return true
        case .userCancelled, .pending:
            return false
        @unknown default:
            return false
        }
    }
    
    public func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }
    
    public func isPurchased(for id: String) -> Bool {
        purchasedProductIds.contains(id)
    }
    
    private func verifyPurchase(_ verification: VerificationResult<Transaction>) throws -> Transaction {
        switch verification {
        case .unverified:
            throw NSError(domain: "Verification failed", code: 1, userInfo: nil)
        case .verified(let transaction):
            return transaction
        }
    }
    
    private func updatePurchasedProducts() async {
        var purchasedProductIds = Set<String>()
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            var isExpired = false
            if let expirationDate = transaction.expirationDate {
                isExpired = expirationDate < Date()
            }
            
            if transaction.revocationDate == nil || !isExpired {
                purchasedProductIds.insert(transaction.productID)
            } else {
                purchasedProductIds.remove(transaction.productID)
            }
        }
        self.purchasedProductIds = purchasedProductIds
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await updatePurchasedProducts()
            }
        }
    }
}
