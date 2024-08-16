//
//  IAPRepositoryImpl.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 8/16/24.
//

import StoreKit
import EcoNotifyEntity

final class IAPRepositoryImpl: IAPRepository {
    static func retrieveProducts(for ids: [String]) async throws -> [Product] {
        try await Product.products(for: ids)
    }
    
    static func restorePurchases() async throws {
        try await AppStore.sync()
    }
    
    static func currentEntitlements() -> Transaction.Transactions {
        Transaction.currentEntitlements
    }
    
    static func observeTransactionUpdates(
        onUpdate: @escaping @Sendable (VerificationResult<Transaction>) async -> Void
    ) -> Task<Void, Never> {
        Task(priority: .background) {
            for await result in Transaction.updates {
                await onUpdate(result)
            }
        }
    }
}

