//
//  ProductListInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class ProductListInteractor: ProductListInteractorProtocol {
    
    weak var presenter: ProductListInteractorOutputProtocol?
    
    // Dependency Injection - Protocol-based service
    private let productService: ProductServiceProtocol
    
    // Task cancellation için - hafıza yönetimi
    private var fetchProductsTask: Task<Void, Never>?
    private var fetchCategoriesTask: Task<Void, Never>?
    private var fetchByCategoryTask: Task<Void, Never>?
    
    // Initializer - Dependency Injection
    init(productService: ProductServiceProtocol = NetworkManager.shared) {
        self.productService = productService
    }
    
    func fetchProducts() {
        // Önceki task'ı iptal et (yeni istek gelirse)
        fetchProductsTask?.cancel()
        
        // Yeni async task başlat
        fetchProductsTask = Task { [weak self] in
            do {
                // Async/await ile network isteği - Dependency Injection kullan
                let products = try await self?.productService.fetchProducts() ?? []
                
                // Task iptal edildiyse devam etme
                guard !Task.isCancelled, let self = self else { return }
                
                // Interactor UI bilmemeli - Ham veriyi döndür
                self.presenter?.didFetchProducts(products)
            } catch {
                // Task iptal edildiyse hata gönderme
                guard !Task.isCancelled, let self = self else { return }
                
                // Hata durumunu presenter'a bildir
                self.presenter?.didFailWithError(error)
            }
        }
    }
    
    func fetchCategories() {
        // Önceki task'ı iptal et
        fetchCategoriesTask?.cancel()
        
        fetchCategoriesTask = Task { [weak self] in
            do {
                let categories = try await self?.productService.fetchCategories() ?? []
                
                guard !Task.isCancelled, let self = self else { return }
                
                self.presenter?.didFetchCategories(categories)
            } catch {
                guard !Task.isCancelled, let self = self else { return }
                
                self.presenter?.didFailWithError(error)
            }
        }
    }
    
    func fetchProductsByCategory(category: String) {
        // Önceki task'ı iptal et
        fetchByCategoryTask?.cancel()
        
        fetchByCategoryTask = Task { [weak self] in
            do {
                let products = try await self?.productService.fetchProductsByCategory(category: category) ?? []
                
                guard !Task.isCancelled, let self = self else { return }
                
                self.presenter?.didFetchProducts(products)
            } catch {
                guard !Task.isCancelled, let self = self else { return }
                
                self.presenter?.didFailWithError(error)
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
