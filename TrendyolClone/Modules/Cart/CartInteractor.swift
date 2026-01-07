//
//  CartInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class CartInteractor: CartInteractorProtocol {
    
    weak var presenter: CartInteractorOutputProtocol?
    
    // Repository Pattern - Data layer abstraction
    private let productRepository: ProductRepositoryProtocol
    
    // Task cancellation için - hafıza yönetimi
    private var fetchTask: Task<Void, Never>?
    
    // Initializer - Dependency Injection
    init(productRepository: ProductRepositoryProtocol = ProductRepository()) {
        self.productRepository = productRepository
    }
    
    func fetchCartItems() {
        // Önceki task'ı iptal et (yeni istek gelirse)
        fetchTask?.cancel()
        
        // Yeni async task başlat
        fetchTask = Task { [weak self] in
            do {
                // 1. CartManager'dan sepet öğelerini al (Actor'a await ile erişim)
                let cartItems = await CartManager.shared.getCartItems()
                
                // Task iptal edildiyse devam etme
                guard !Task.isCancelled, let self = self else { return }
                
                // Eğer sepet boşsa boş array döndür
                guard !cartItems.isEmpty else {
                    self.presenter?.didFetchCartItems([])
                    return
                }
                
                // 2. Tüm ürünleri çek (Repository Pattern - önce cache'den kontrol eder)
                let allProducts = try await self.productRepository.getProducts()
                
                // Task iptal edildiyse devam etme
                guard !Task.isCancelled else { return }
                
                // 3. Sepet öğelerini Product ile eşleştir
                let cartItemViewModels: [CartItemViewModel] = cartItems.compactMap { cartItem in
                    guard let product = allProducts.first(where: { $0.id == cartItem.productId }) else {
                        return nil
                    }
                    return CartItemViewModel(product: product, quantity: cartItem.quantity)
                }
                
                // Interactor UI bilmemeli - Ham veriyi döndür
                self.presenter?.didFetchCartItems(cartItemViewModels)
            } catch {
                // Task iptal edildiyse hata gönderme
                guard !Task.isCancelled, let self = self else { return }
                
                // Hata durumunu presenter'a bildir
                self.presenter?.didFailWithError(error)
            }
        }
    }
    
    func increaseQuantity(productId: Int) {
        // Actor'a await ile erişim
        Task { [weak self] in
            await CartManager.shared.increaseQuantity(productId: productId)
            self?.presenter?.didUpdateCart()
        }
    }
    
    func decreaseQuantity(productId: Int) {
        // Actor'a await ile erişim
        Task { [weak self] in
            await CartManager.shared.decreaseQuantity(productId: productId)
            self?.presenter?.didUpdateCart()
        }
    }
    
    func removeItem(productId: Int) {
        // Actor'a await ile erişim
        Task { [weak self] in
            await CartManager.shared.removeFromCart(productId: productId)
            self?.presenter?.didUpdateCart()
        }
    }
    
    func clearCart() {
        // Actor'a await ile erişim
        Task { [weak self] in
            await CartManager.shared.clearCart()
            self?.presenter?.didUpdateCart()
        }
    }
    
    /// Tüm aktif task'ları iptal et - hafıza temizliği için
    func cancelAllTasks() {
        fetchTask?.cancel()
    }
}

