//
//  ProductRepositoryProtocol.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Repository Pattern - Data layer abstraction
/// Repository, veri kaynağını (Network, Cache, Database) Interactor'dan gizler
/// 
/// FAYDALARI:
/// 1. Cache yönetimi - Offline support
/// 2. Test edilebilirlik - Mock repository kullanılabilir
/// 3. Data source değişikliği - Network yerine Database kullanılabilir
/// 4. Single Responsibility - Interactor sadece business logic ile ilgilenir
protocol ProductRepositoryProtocol {
    /// Tüm ürünleri getir (önce cache'den, yoksa network'ten)
    func getProducts() async throws -> [Product]
    
    /// Cache'den ürünleri getir (network isteği yapmaz)
    func getCachedProducts() -> [Product]?
    
    /// Kategoriye göre ürünleri getir
    func getProductsByCategory(_ category: String) async throws -> [Product]
    
    /// ID'ye göre tek ürün getir
    func getProduct(id: Int) async throws -> Product
    
    /// Tüm kategorileri getir
    func getCategories() async throws -> [String]
    
    /// Cache'i temizle
    func clearCache()
}

