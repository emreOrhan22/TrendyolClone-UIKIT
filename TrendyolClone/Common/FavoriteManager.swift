//
//  FavoriteManager.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Actor-based FavoriteManager - Modern Swift 5.5+ yaklaşımı
/// Actor kullanarak thread-safety otomatik sağlanır (Data Race önlenir)
/// 
/// NEDEN ACTOR?
/// - Read-modify-write pattern thread-safe değildi
/// - Eşzamanlı erişimde veri kaybı riski vardı
/// - Actor, tüm state değişikliklerini seri hale getirir (otomatik lock)
actor FavoriteManager {
    
    static let shared = FavoriteManager()
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteProductIds"
    
    private init() {}
    
    /// Favorilere ürün ekle
    /// Actor içinde olduğu için otomatik thread-safe
    func addFavorite(productId: Int) {
        var favorites = getFavorites()
        if !favorites.contains(productId) {
            favorites.append(productId)
            saveFavorites(favorites)
        }
    }
    
    /// Favorilerden ürün çıkar
    /// Actor içinde olduğu için otomatik thread-safe
    func removeFavorite(productId: Int) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == productId }
        saveFavorites(favorites)
    }
    
    /// Ürün favorilerde var mı kontrol et
    /// Actor içinde olduğu için otomatik thread-safe
    func isFavorite(productId: Int) -> Bool {
        return getFavorites().contains(productId)
    }
    
    /// Favori durumunu değiştir (ekle/çıkar)
    /// Actor içinde olduğu için otomatik thread-safe
    func toggleFavorite(productId: Int) {
        if isFavorite(productId: productId) {
            removeFavorite(productId: productId)
        } else {
            addFavorite(productId: productId)
        }
    }
    
    /// Tüm favori ürün ID'lerini döndürür
    /// Actor içinde olduğu için otomatik thread-safe
    func getFavoriteIds() -> [Int] {
        return getFavorites()
    }
    
    // MARK: - Private Methods
    
    /// Favori ürün ID'lerini UserDefaults'tan oku
    private func getFavorites() -> [Int] {
        return userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
    }
    
    /// Favori ürün ID'lerini UserDefaults'a kaydet
    private func saveFavorites(_ favorites: [Int]) {
        userDefaults.set(favorites, forKey: favoritesKey)
    }
}

