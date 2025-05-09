//
//  PurchaseManager.swift
//  Gridfy
//
//  Created by Viacheslav Kharkov on 15.04.2023.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
    private let productIds = ["plus_version"]
    private var productsLoaded = false
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs = Set<String>()
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
    }

    deinit {
        updates?.cancel()
    }
    
    // ----- LOAD PRODUCTS
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }

    // ----- PURCHASE
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()

        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
            print("verified-")
        case let .success(.unverified(_, error)):
            print("unverified-")
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    
    public enum PurchaseResult {
        case success(VerificationResult<Transaction>)
        case userCancelled
        case pending
    }

    public enum VerificationResult<SignedType> {
        case verified(SignedType)
        case unverified
    }

    // ----- HAS UNLOCKED
    var hasUnlockedPlus: Bool {
       return !self.purchasedProductIDs.isEmpty
    }

    // ----- UPDATE PRODUCTS
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
}
