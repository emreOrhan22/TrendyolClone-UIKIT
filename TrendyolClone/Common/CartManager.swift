//
//  CartManager.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Sepet öğesi - Ürün ve miktar bilgisi
struct CartItem: Codable {
    let productId: Int
    var quantity: Int
    
    init(productId: Int, quantity: Int = 1) {
        self.productId = productId
        self.quantity = quantity
    }
}

final class CartManager {
    
    static let shared = CartManager()
    
    private let userDefaults = UserDefaults.standard
    private let cartKey = "cartItems"
    
    private init() {}
    
    // MARK: - Add/Remove Operations
    
    /// Sepete ürün ekle veya miktarını artır
    func addToCart(productId: Int, quantity: Int = 1) {
        var cartItems = getCartItems()
        
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            // Ürün sepette varsa miktarını artır
            cartItems[index].quantity += quantity
        } else {
            // Ürün sepette yoksa ekle
            cartItems.append(CartItem(productId: productId, quantity: quantity))
        }
        
        saveCartItems(cartItems)
    }
    
    /// Sepetten ürün çıkar
    func removeFromCart(productId: Int) {
        var cartItems = getCartItems()
        cartItems.removeAll { $0.productId == productId }
        saveCartItems(cartItems)
    }
    
    /// Sepetteki ürün miktarını güncelle
    func updateQuantity(productId: Int, quantity: Int) {
        guard quantity > 0 else {
            removeFromCart(productId: productId)
            return
        }
        
        var cartItems = getCartItems()
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            cartItems[index].quantity = quantity
            saveCartItems(cartItems)
        }
    }
    
    /// Sepetteki ürün miktarını artır
    func increaseQuantity(productId: Int) {
        var cartItems = getCartItems()
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            cartItems[index].quantity += 1
            saveCartItems(cartItems)
        }
    }
    
    /// Sepetteki ürün miktarını azalt
    func decreaseQuantity(productId: Int) {
        var cartItems = getCartItems()
        if let index = cartItems.firstIndex(where: { $0.productId == productId }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                // Miktar 1 ise ürünü sepetten çıkar
                cartItems.remove(at: index)
            }
            saveCartItems(cartItems)
        }
    }
    
    // MARK: - Query Operations
    
    /// Sepetteki tüm ürün ID'lerini ve miktarlarını döndürür
    func getCartItems() -> [CartItem] {
        guard let data = userDefaults.data(forKey: cartKey),
              let items = try? JSONDecoder().decode([CartItem].self, from: data) else {
            return []
        }
        return items
    }
    
    /// Sepetteki ürün miktarını döndürür
    func getQuantity(productId: Int) -> Int {
        return getCartItems().first(where: { $0.productId == productId })?.quantity ?? 0
    }
    
    /// Ürün sepette var mı kontrol et
    func isInCart(productId: Int) -> Bool {
        return getCartItems().contains(where: { $0.productId == productId })
    }
    
    /// Sepetteki toplam ürün sayısını döndürür
    func getTotalItemCount() -> Int {
        return getCartItems().reduce(0) { $0 + $1.quantity }
    }
    
    /// Sepeti temizle
    func clearCart() {
        userDefaults.removeObject(forKey: cartKey)
        // Sepet temizlendiğinde bildirim gönder
        NotificationCenter.default.post(name: NSNotification.Name("CartDidUpdate"), object: nil)
    }
    
    // MARK: - Private Methods
    
    private func saveCartItems(_ items: [CartItem]) {
        if let data = try? JSONEncoder().encode(items) {
            userDefaults.set(data, forKey: cartKey)
            // Sepet değiştiğinde bildirim gönder
            NotificationCenter.default.post(name: NSNotification.Name("CartDidUpdate"), object: nil)
        }
    }
}

