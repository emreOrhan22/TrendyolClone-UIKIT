//
//  FavoritesInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class FavoritesInteractor: FavoritesInteractorProtocol {
    
    weak var presenter: FavoritesInteractorOutputProtocol?
    
    // Dependency Injection - Protocol-based service
    private let productService: ProductServiceProtocol
    
    // Task cancellation için - hafıza yönetimi
    private var fetchTask: Task<Void, Never>?
    
    // Initializer - Dependency Injection
    init(productService: ProductServiceProtocol = NetworkManager.shared) {
        self.productService = productService
    }
    
    func fetchFavoriteProducts() {
        // Önceki task'ı iptal et (yeni istek gelirse)
        fetchTask?.cancel()
        
        // Yeni async task başlat
        fetchTask = Task { [weak self] in
            do {
                // 1. FavoriteManager'dan favori ID'leri al
                let favoriteIds = FavoriteManager.shared.getFavoriteIds()
                
                // Task iptal edildiyse devam etme
                guard !Task.isCancelled, let self = self else { return }
                
                // Eğer favori yoksa boş array döndür
                guard !favoriteIds.isEmpty else {
                    self.presenter?.didFetchFavoriteProducts([])
                    return
                }
                
                // 2. Tüm ürünleri çek (verimlilik için - tek network isteği)
                let allProducts = try await self.productService.fetchProducts()
                
                // Task iptal edildiyse devam etme
                guard !Task.isCancelled else { return }
                
                // 3. Favori ID'lere göre filtrele
                let favoriteProducts = allProducts.filter { favoriteIds.contains($0.id) }
                
                // 4. ID sırasına göre sırala (FavoriteManager'daki sıraya göre)
                let sortedProducts = favoriteIds.compactMap { id in
                    favoriteProducts.first { $0.id == id }
                }
                
                // Interactor UI bilmemeli - Ham veriyi döndür
                self.presenter?.didFetchFavoriteProducts(sortedProducts)
            } catch {
                // Task iptal edildiyse hata gönderme
                guard !Task.isCancelled, let self = self else { return }
                
                // Hata durumunu presenter'a bildir
                self.presenter?.didFailWithError(error)
            }
        }
    }
    
    /// Tüm aktif task'ları iptal et - hafıza temizliği için
    func cancelAllTasks() {
        fetchTask?.cancel()
    }
}

