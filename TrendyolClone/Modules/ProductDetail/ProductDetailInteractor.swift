//
//  ProductDetailInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class ProductDetailInteractor: ProductDetailInteractorProtocol {
    
    weak var presenter: ProductDetailInteractorOutputProtocol?
    
    /// Favori durumunu kontrol et
    func checkFavoriteStatus(productId: Int) {
        // Actor'a await ile erişim
        Task { @MainActor [weak self] in
            let isFavorite = await FavoriteManager.shared.isFavorite(productId: productId)
            self?.presenter?.didCheckFavoriteStatus(isFavorite: isFavorite)
        }
    }
    
    /// Favori durumunu değiştir (ekle/çıkar)
    func toggleFavorite(productId: Int) {
        // Actor'a await ile erişim
        Task { @MainActor [weak self] in
            await FavoriteManager.shared.toggleFavorite(productId: productId)
            let isFavorite = await FavoriteManager.shared.isFavorite(productId: productId)
            self?.presenter?.didToggleFavorite(isFavorite: isFavorite)
        }
    }
    
    /// Sepete ürün ekle
    func addToCart(productId: Int) {
        // Actor'a await ile erişim
        Task { @MainActor [weak self] in
            await CartManager.shared.addToCart(productId: productId)
            self?.presenter?.didAddToCart()
        }
    }
}

