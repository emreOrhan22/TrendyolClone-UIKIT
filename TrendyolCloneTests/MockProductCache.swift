//
//  MockProductCache.swift
//  TrendyolCloneTests
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation
@testable import TrendyolClone

/// Mock ProductCache - Test için sahte cache
/// Gerçek UserDefaults kullanmaz, sadece memory'de tutar
class MockProductCache: ProductCacheProtocol {
    
    // Memory'de tutulan cache verileri
    private var cachedProducts: [Product]?
    private var cachedCategories: [String]?
    private var cachedProductsByCategory: [String: [Product]] = [:]
    
    // Cache'i temizleme çağrı sayısı
    var clearCallCount = 0
    
    func saveProducts(_ products: [Product]) {
        cachedProducts = products
    }
    
    func getProducts() -> [Product]? {
        return cachedProducts
    }
    
    func saveProducts(_ products: [Product], for category: String) {
        cachedProductsByCategory[category] = products
    }
    
    func getProducts(for category: String) -> [Product]? {
        return cachedProductsByCategory[category]
    }
    
    func saveCategories(_ categories: [String]) {
        cachedCategories = categories
    }
    
    func getCategories() -> [String]? {
        return cachedCategories
    }
    
    func clear() {
        clearCallCount += 1
        cachedProducts = nil
        cachedCategories = nil
        cachedProductsByCategory.removeAll()
    }
}

