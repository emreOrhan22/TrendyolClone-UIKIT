//
//  MockProductService.swift
//  TrendyolCloneTests
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation
@testable import TrendyolClone

/// Mock ProductService - Test için sahte network service
/// Network isteği yapmaz, sadece belirlediğimiz veriyi döndürür
class MockProductService: ProductServiceProtocol {
    
    // Test için kontrol edilebilir değişkenler
    var shouldFail = false
    var failError: Error?
    var productsToReturn: [Product] = []
    var categoriesToReturn: [String] = []
    
    // Kaç kez çağrıldığını takip et
    var fetchProductsCallCount = 0
    var fetchCategoriesCallCount = 0
    var fetchProductsByCategoryCallCount = 0
    
    func fetchProducts() async throws -> [Product] {
        fetchProductsCallCount += 1
        
        if shouldFail {
            throw failError ?? NetworkError.invalidResponse
        }
        
        return productsToReturn
    }
    
    func fetchCategories() async throws -> [String] {
        fetchCategoriesCallCount += 1
        
        if shouldFail {
            throw failError ?? NetworkError.invalidResponse
        }
        
        return categoriesToReturn
    }
    
    func fetchProductsByCategory(category: String) async throws -> [Product] {
        fetchProductsByCategoryCallCount += 1
        
        if shouldFail {
            throw failError ?? NetworkError.invalidResponse
        }
        
        // Kategoriye göre filtrele
        return productsToReturn.filter { $0.category == category }
    }
    
    func fetchProduct(id: Int) async throws -> Product {
        if shouldFail {
            throw failError ?? NetworkError.invalidResponse
        }
        
        guard let product = productsToReturn.first(where: { $0.id == id }) else {
            throw NetworkError.httpError(404)
        }
        
        return product
    }
}

