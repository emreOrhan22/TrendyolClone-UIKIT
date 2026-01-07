//
//  ProductRepository.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Repository Pattern Implementation
/// 
/// Repository, veri kaynağını (Network, Cache) Interactor'dan gizler
/// 
/// ÇALIŞMA MANTIĞI:
/// 1. Önce cache'den kontrol et
/// 2. Cache varsa ve fresh ise cache'den döndür
/// 3. Cache yoksa veya stale ise network'ten çek
/// 4. Network'ten gelen veriyi cache'e kaydet
/// 5. Veriyi döndür
class ProductRepository: ProductRepositoryProtocol {
    
    // Dependency Injection
    private let networkService: ProductServiceProtocol
    private let cache: ProductCacheProtocol
    
    // Initializer - Dependency Injection
    init(
        networkService: ProductServiceProtocol = NetworkManager.shared,
        cache: ProductCacheProtocol = ProductCache()
    ) {
        self.networkService = networkService
        self.cache = cache
    }
    
    // MARK: - Get Products
    
    func getProducts() async throws -> [Product] {
        // 1. Önce cache'den kontrol et
        if let cachedProducts = cache.getProducts(), !cachedProducts.isEmpty {
            // Cache'den döndür (hızlı)
            // NOT: Production'da cache freshness kontrolü eklenebilir
            return cachedProducts
        }
        
        // 2. Cache yoksa network'ten çek
        let products = try await networkService.fetchProducts()
        
        // 3. Network'ten gelen veriyi cache'e kaydet
        cache.saveProducts(products)
        
        // 4. Veriyi döndür
        return products
    }
    
    func getCachedProducts() -> [Product]? {
        return cache.getProducts()
    }
    
    // MARK: - Get Products by Category
    
    func getProductsByCategory(_ category: String) async throws -> [Product] {
        // 1. Önce cache'den kontrol et
        if let cachedProducts = cache.getProducts(for: category), !cachedProducts.isEmpty {
            return cachedProducts
        }
        
        // 2. Cache yoksa network'ten çek
        let products = try await networkService.fetchProductsByCategory(category: category)
        
        // 3. Network'ten gelen veriyi cache'e kaydet
        cache.saveProducts(products, for: category)
        
        // 4. Veriyi döndür
        return products
    }
    
    // MARK: - Get Single Product
    
    func getProduct(id: Int) async throws -> Product {
        // Tek ürün için cache kontrolü yapmıyoruz (basitlik için)
        // Production'da tek ürün için de cache eklenebilir
        return try await networkService.fetchProduct(id: id)
    }
    
    // MARK: - Get Categories
    
    func getCategories() async throws -> [String] {
        // 1. Önce cache'den kontrol et
        if let cachedCategories = cache.getCategories(), !cachedCategories.isEmpty {
            return cachedCategories
        }
        
        // 2. Cache yoksa network'ten çek
        let categories = try await networkService.fetchCategories()
        
        // 3. Network'ten gelen veriyi cache'e kaydet
        cache.saveCategories(categories)
        
        // 4. Veriyi döndür
        return categories
    }
    
    // MARK: - Clear Cache
    
    func clearCache() {
        cache.clear()
    }
}

