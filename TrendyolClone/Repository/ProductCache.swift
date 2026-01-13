//
//  ProductCache.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Cache wrapper - TTL (Time To Live) desteği için
private struct CachedData<T: Codable>: Codable {
    let data: T
    let timestamp: Date
    
    var isExpired: Bool {
        // 1 saat (3600 saniye) sonra expire et
        let expirationTime: TimeInterval = 3600
        return Date().timeIntervalSince(timestamp) > expirationTime
    }
}

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
        let cachedData = CachedData(data: products, timestamp: Date())
        if let encoded = try? JSONEncoder().encode(cachedData) {
            userDefaults.set(encoded, forKey: CacheKey.products)
        }
    }
    
    func getProducts() -> [Product]? {
        guard let data = userDefaults.data(forKey: CacheKey.products),
              let cachedData = try? JSONDecoder().decode(CachedData<[Product]>.self, from: data) else {
            return nil
        }
        
        // TTL kontrolü - Expire olmuşsa nil döndür
        if cachedData.isExpired {
            userDefaults.removeObject(forKey: CacheKey.products)
            return nil
        }
        
        return cachedData.data
    }
    
    // MARK: - Products by Category
    
    func saveProducts(_ products: [Product], for category: String) {
        let cachedData = CachedData(data: products, timestamp: Date())
        if let encoded = try? JSONEncoder().encode(cachedData) {
            userDefaults.set(encoded, forKey: CacheKey.productsForCategory(category))
        }
    }
    
    func getProducts(for category: String) -> [Product]? {
        guard let data = userDefaults.data(forKey: CacheKey.productsForCategory(category)),
              let cachedData = try? JSONDecoder().decode(CachedData<[Product]>.self, from: data) else {
            return nil
        }
        
        // TTL kontrolü - Expire olmuşsa nil döndür
        if cachedData.isExpired {
            userDefaults.removeObject(forKey: CacheKey.productsForCategory(category))
            return nil
        }
        
        return cachedData.data
    }
    
    // MARK: - Categories
    
    func saveCategories(_ categories: [String]) {
        let cachedData = CachedData(data: categories, timestamp: Date())
        if let encoded = try? JSONEncoder().encode(cachedData) {
            userDefaults.set(encoded, forKey: CacheKey.categories)
        }
    }
    
    func getCategories() -> [String]? {
        guard let data = userDefaults.data(forKey: CacheKey.categories),
              let cachedData = try? JSONDecoder().decode(CachedData<[String]>.self, from: data) else {
            return nil
        }
        
        // TTL kontrolü - Expire olmuşsa nil döndür
        if cachedData.isExpired {
            userDefaults.removeObject(forKey: CacheKey.categories)
            return nil
        }
        
        return cachedData.data
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

