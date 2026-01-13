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
    /// Offline durumda ekleme yapılmaz - Stok kontrolü ve güncel veri için internet gerekli
    func addToCart(productId: Int) {
        Task { @MainActor [weak self] in
            // 1. Önce network durumunu kontrol et
            let isOnline = await NetworkMonitor.shared.checkConnection()
            
            guard isOnline else {
                // Offline durumda sepete ekleme yapma
                // Kullanıcıya bilgi ver
                self?.presenter?.didFailToAddToCart(
                    message: "İnternet bağlantınız yok. Sepete eklemek için lütfen internet bağlantınızı kontrol edin."
                )
                return
            }
            
            // 2. Online ise sepete ekle
            await CartManager.shared.addToCart(productId: productId)
            self?.presenter?.didAddToCart()
        }
    }
}

