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
        // Async/await kullanarak favori durumunu kontrol et
        Task { @MainActor [weak self] in
            let isFavorite = FavoriteManager.shared.isFavorite(productId: productId)
            self?.presenter?.didCheckFavoriteStatus(isFavorite: isFavorite)
        }
    }
    
    /// Favori durumunu değiştir (ekle/çıkar)
    func toggleFavorite(productId: Int) {
        // Async/await kullanarak favori durumunu değiştir
        Task { @MainActor [weak self] in
            FavoriteManager.shared.toggleFavorite(productId: productId)
            let isFavorite = FavoriteManager.shared.isFavorite(productId: productId)
            self?.presenter?.didToggleFavorite(isFavorite: isFavorite)
        }
    }
}

