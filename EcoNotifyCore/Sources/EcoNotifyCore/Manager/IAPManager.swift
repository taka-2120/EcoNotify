//
//  IAPManager.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 8/13/24.
//

import Foundation
import StoreKit
import EcoNotifyEntity

@Observable
public class IAPManager {
    private let iapService = IAPServiceImpl()
    private var purchasedProductIds = Set<String>()
    private var subscription: Task<Void, Never>? = nil
    
    public var products = [Product]()
    public var isAdsRemoved: Bool {
        purchased(for: Constant.ProductId.removeAds.rawValue) != nil
    }
    
    @MainActor public static let shared = IAPManager()
    
    private init() {
        subscription = iapService.observeTransactionUpdates()
    }

    deinit {
        subscription?.cancel()
    }
    
    @MainActor
    public func fetchProducts() async throws {
        products = try await iapService.retrieveProducts()
        purchasedProductIds = await iapService.updatePurchasedProducts()
    }
    
    @MainActor
    public func purchase(_ product: Product) async throws -> Bool {
        try await iapService.purchase(product)
    }
    
    @MainActor
    public func restorePurchases() async throws {
        purchasedProductIds = try await iapService.restorePurchases()
    }
    
    public func getProduct(for id: String) -> Product? {
        products.first(where: { $0.id == id })
    }
    
    public func purchased(for id: String) -> Product? {
        purchasedProductIds.contains(id)
        ? products.first(where: { $0.id == id })
        : nil
    }
}
