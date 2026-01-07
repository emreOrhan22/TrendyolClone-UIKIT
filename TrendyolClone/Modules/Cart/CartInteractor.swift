//
//  CartInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class CartInteractor: CartInteractorProtocol {
    
    weak var presenter: CartInteractorOutputProtocol?
    
    // Dependency Injection - Protocol-based service
    private let productService: ProductServiceProtocol
    
    // Task cancellation için - hafıza yönetimi
    private var fetchTask: Task<Void, Never>?
    
    // Initializer - Dependency Injection
    init(productService: ProductServiceProtocol = NetworkManager.shared) {
        self.productService = productService
    }
    
    func fetchCartItems() {
        // Önceki task'ı iptal et (yeni istek gelirse)
        fetchTask?.cancel()
        
        // Yeni async task başlat
        fetchTask = Task { [weak self] in
            do {
                // 1. CartManager'dan sepet öğelerini al
                let cartItems = CartManager.shared.getCartItems()
                
                // Task iptal edildiyse devam etme
                guard !Task.isCancelled, let self = self else { return }
                
                // Eğer sepet boşsa boş array döndür
                guard !cartItems.isEmpty else {
                    self.presenter?.didFetchCartItems([])
                    return
                }
                
                // 2. Tüm ürünleri çek (verimlilik için - tek network isteği)
                let allProducts = try await self.productService.fetchProducts()
                
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
        CartManager.shared.increaseQuantity(productId: productId)
        presenter?.didUpdateCart()
    }
    
    func decreaseQuantity(productId: Int) {
        CartManager.shared.decreaseQuantity(productId: productId)
        presenter?.didUpdateCart()
    }
    
    func removeItem(productId: Int) {
        CartManager.shared.removeFromCart(productId: productId)
        presenter?.didUpdateCart()
    }
    
    func clearCart() {
        CartManager.shared.clearCart()
        presenter?.didUpdateCart()
    }
    
    /// Tüm aktif task'ları iptal et - hafıza temizliği için
    func cancelAllTasks() {
        fetchTask?.cancel()
    }
}

