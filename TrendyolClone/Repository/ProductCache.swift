//
//  ProductCache.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Memory-based cache implementasyonu
/// UserDefaults kullanarak basit bir cache mekanizması
/// 
/// NOT: Production'da daha gelişmiş cache (NSCache, Core Data, vs.) kullanılabilir
class ProductCache: ProductCacheProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    // Cache key'leri
    private enum CacheKey {
        static let products = "cached_products"
        static let categories = "cached_categories"
        static func productsForCategory(_ category: String) -> String {
            return "cached_products_category_\(category)"
        }
    }
    
    // MARK: - Products
    
    func saveProducts(_ products: [Product]) {
        if let encoded = try? JSONEncoder().encode(products) {
            userDefaults.set(encoded, forKey: CacheKey.products)
        }
    }
    
    func getProducts() -> [Product]? {
        guard let data = userDefaults.data(forKey: CacheKey.products),
              let products = try? JSONDecoder().decode([Product].self, from: data) else {
            return nil
        }
        return products
    }
    
    // MARK: - Products by Category
    
    func saveProducts(_ products: [Product], for category: String) {
        if let encoded = try? JSONEncoder().encode(products) {
            userDefaults.set(encoded, forKey: CacheKey.productsForCategory(category))
        }
    }
    
    func getProducts(for category: String) -> [Product]? {
        guard let data = userDefaults.data(forKey: CacheKey.productsForCategory(category)),
              let products = try? JSONDecoder().decode([Product].self, from: data) else {
            return nil
        }
        return products
    }
    
    // MARK: - Categories
    
    func saveCategories(_ categories: [String]) {
        userDefaults.set(categories, forKey: CacheKey.categories)
    }
    
    func getCategories() -> [String]? {
        return userDefaults.array(forKey: CacheKey.categories) as? [String]
    }
    
    // MARK: - Clear
    
    func clear() {
        // Tüm cache key'lerini temizle
        userDefaults.removeObject(forKey: CacheKey.products)
        userDefaults.removeObject(forKey: CacheKey.categories)
        
        // Kategori bazlı cache'leri temizlemek için tüm key'leri bul
        // (Basit implementasyon - Production'da daha iyi yönetilebilir)
        let keys = userDefaults.dictionaryRepresentation().keys
        for key in keys {
            if key.hasPrefix("cached_products_category_") {
                userDefaults.removeObject(forKey: key)
            }
        }
    }
}

