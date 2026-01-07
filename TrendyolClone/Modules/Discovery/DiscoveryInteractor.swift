//
//  DiscoveryInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class DiscoveryInteractor: DiscoveryInteractorProtocol {
    
    weak var presenter: DiscoveryInteractorOutputProtocol?
    
    // Repository Pattern - Data layer abstraction
    // Interactor artık direkt NetworkManager değil, Repository kullanıyor
    // Bu sayede cache yönetimi, offline support, test edilebilirlik sağlanıyor
    private let productRepository: ProductRepositoryProtocol
    
    // Task cancellation için - hafıza yönetimi
    private var fetchProductsTask: Task<Void, Never>?
    private var fetchCategoriesTask: Task<Void, Never>?
    private var fetchByCategoryTask: Task<Void, Never>?
    
    // Initializer - Dependency Injection
    init(productRepository: ProductRepositoryProtocol = ProductRepository()) {
        self.productRepository = productRepository
    }
    
    func fetchProducts() {
        // Önceki task'ı iptal et (yeni istek gelirse)
        fetchProductsTask?.cancel()
        
        // Yeni async task başlat
        fetchProductsTask = Task { [weak self] in
            do {
                // Repository Pattern kullanımı
                // Repository önce cache'den kontrol eder, yoksa network'ten çeker
                let products = try await self?.productRepository.getProducts() ?? []
                
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
                // Repository Pattern kullanımı
                let categories = try await self?.productRepository.getCategories() ?? []
                
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
                // Repository Pattern kullanımı
                let products = try await self?.productRepository.getProductsByCategory(category) ?? []
                
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
