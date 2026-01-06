//
//  FavoriteManager.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

final class FavoriteManager {
    
    static let shared = FavoriteManager()
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteProductIds"
    
    private init() {}
    
    func addFavorite(productId: Int) {
        var favorites = getFavorites()
        if !favorites.contains(productId) {
            favorites.append(productId)
            saveFavorites(favorites)
        }
    }
    
    func removeFavorite(productId: Int) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == productId }
        saveFavorites(favorites)
    }
    
    func isFavorite(productId: Int) -> Bool {
        return getFavorites().contains(productId)
    }
    
    func toggleFavorite(productId: Int) {
        if isFavorite(productId: productId) {
            removeFavorite(productId: productId)
        } else {
            addFavorite(productId: productId)
        }
    }
    
    /// Tüm favori ürün ID'lerini döndürür
    func getFavoriteIds() -> [Int] {
        return getFavorites()
    }
    
    private func getFavorites() -> [Int] {
        return userDefaults.array(forKey: favoritesKey) as? [Int] ?? []
    }
    
    private func saveFavorites(_ favorites: [Int]) {
        userDefaults.set(favorites, forKey: favoritesKey)
    }
}

