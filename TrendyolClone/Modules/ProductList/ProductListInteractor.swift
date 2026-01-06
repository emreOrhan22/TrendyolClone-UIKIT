//
//  ProductListInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class ProductListInteractor: ProductListInteractorProtocol {
    
    weak var presenter: ProductListInteractorOutputProtocol?
    
    // Task cancellation için - hafıza yönetimi
    private var fetchProductsTask: Task<Void, Never>?
    private var fetchCategoriesTask: Task<Void, Never>?
    private var fetchByCategoryTask: Task<Void, Never>?
    
    func fetchProducts() {
        // Önceki task'ı iptal et (yeni istek gelirse)
        fetchProductsTask?.cancel()
        
        // Yeni async task başlat
        fetchProductsTask = Task { [weak self] in
            do {
                // Async/await ile network isteği - closure yerine
                let products = try await NetworkManager.shared.fetchProducts()
                
                // Task iptal edildiyse devam etme
                guard !Task.isCancelled else { return }
                
                // Presenter'a sonucu bildir
                await MainActor.run {
                    self?.presenter?.didFetchProducts(products)
                }
            } catch {
                // Task iptal edildiyse hata gönderme
                guard !Task.isCancelled else { return }
                
                // Hata durumunu presenter'a bildir
                await MainActor.run {
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func fetchCategories() {
        // Önceki task'ı iptal et
        fetchCategoriesTask?.cancel()
        
        fetchCategoriesTask = Task { [weak self] in
            do {
                let categories = try await NetworkManager.shared.fetchCategories()
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self?.presenter?.didFetchCategories(categories)
                }
            } catch {
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func fetchProductsByCategory(category: String) {
        // Önceki task'ı iptal et
        fetchByCategoryTask?.cancel()
        
        fetchByCategoryTask = Task { [weak self] in
            do {
                let products = try await NetworkManager.shared.fetchProductsByCategory(category: category)
                
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self?.presenter?.didFetchProducts(products)
                }
            } catch {
                guard !Task.isCancelled else { return }
                
                await MainActor.run {
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    /// Tüm aktif task'ları iptal et - hafıza temizliği için
    func cancelAllTasks() {
        fetchProductsTask?.cancel()
        fetchCategoriesTask?.cancel()
        fetchByCategoryTask?.cancel()
    }
}
