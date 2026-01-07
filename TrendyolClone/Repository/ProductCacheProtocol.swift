//
//  ProductCacheProtocol.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Cache protokolü - Farklı cache implementasyonları için
/// (Memory cache, Disk cache, Core Data, vs.)
protocol ProductCacheProtocol {
    /// Ürünleri cache'e kaydet
    func saveProducts(_ products: [Product])
    
    /// Cache'den ürünleri oku
    func getProducts() -> [Product]?
    
    /// Kategoriye göre ürünleri cache'e kaydet
    func saveProducts(_ products: [Product], for category: String)
    
    /// Kategoriye göre cache'den ürünleri oku
    func getProducts(for category: String) -> [Product]?
    
    /// Kategorileri cache'e kaydet
    func saveCategories(_ categories: [String])
    
    /// Cache'den kategorileri oku
    func getCategories() -> [String]?
    
    /// Cache'i temizle
    func clear()
}

