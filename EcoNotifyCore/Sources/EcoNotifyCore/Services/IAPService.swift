//
//  IAPService.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 8/16/24.
//

import StoreKit
import EcoNotifyEntity

typealias IAPServiceImpl = IAPService<IAPRepositoryImpl>

final class IAPService<IAPRepo: IAPRepository>: Sendable {
    func retrieveProducts() async throws -> [Product] {
        let productIds = Constant.ProductId.allCases.map { $0.rawValue }
        return try await IAPRepo.retrieveProducts(for: productIds)
    }
    
    func purchase(_ product: Product) async throws -> Bool {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try self.verifyPurchase(verification)
            _ = await updatePurchasedProducts()
            await transaction.finish()
            return true
        case .userCancelled, .pending:
            return false
        @unknown default:
            return false
        }
    }
    
    func updatePurchasedProducts() async -> Set<String> {
        var purchasedProductIds = Set<String>()
        
        for await result in IAPRepo.currentEntitlements() {
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
        return purchasedProductIds
    }
    
    func restorePurchases() async throws -> Set<String> {
        try await IAPRepo.restorePurchases()
        return await updatePurchasedProducts()
    }
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        IAPRepo.observeTransactionUpdates { [weak self] _ in
            _ = await self?.updatePurchasedProducts()
        }
    }
    
    private func verifyPurchase(_ verification: VerificationResult<Transaction>) throws -> Transaction {
        switch verification {
        case .unverified:
            throw NSError(domain: "Verification failed", code: 1, userInfo: nil)
        case .verified(let transaction):
            return transaction
        }
    }
}
