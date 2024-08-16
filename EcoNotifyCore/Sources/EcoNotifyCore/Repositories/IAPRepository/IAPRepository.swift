//
//  IAPRepository.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 8/16/24.
//

import StoreKit

protocol IAPRepository: Sendable {
    static func retrieveProducts(for ids: [String]) async throws -> [Product]
    
    static func restorePurchases() async throws
    
    static func currentEntitlements() -> Transaction.Transactions
    
    static func observeTransactionUpdates(
        onUpdate: @escaping @Sendable (VerificationResult<Transaction>) async -> Void
    ) -> Task<Void, Never>
}
