//
//  StoreKitManager.swift
//  Bebilator
//
//  Created by Vladimir Savic on 9.4.25..
//

import StoreKit

class StoreKitManager {
    private(set) var products: [Product] = []
    
    func fetchProducts() async throws {
        products = try await Product.products(for: ["cucla_pack_3"])
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await transaction.finish()
                return transaction
            case .unverified(_, let error):
                throw error
            }
        case .pending:
            throw PurchaseError.pending
        case .userCancelled:
            throw PurchaseError.userCancelled
        @unknown default:
            throw PurchaseError.unknown
        }
    }
    
    enum PurchaseError: Error {
        case pending, userCancelled, unknown
    }
}
