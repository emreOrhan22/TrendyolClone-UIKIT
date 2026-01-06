//
//  CartPresenter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class CartPresenter: CartPresenterProtocol {
    
    weak var view: CartViewProtocol?
    var interactor: CartInteractorProtocol?
    var router: CartRouterProtocol?
    
    private var cartItems: [CartItemViewModel] = []
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchCartItems()
    }
    
    func viewWillAppear() {
        // Her ekran göründüğünde sepeti yenile
        // (Başka ekrandan sepet değişmiş olabilir)
        view?.showLoading()
        interactor?.fetchCartItems()
    }
    
    func numberOfItems() -> Int {
        return cartItems.count
    }
    
    func cartItemAt(_ index: Int) -> CartItemViewModel? {
        guard index >= 0 && index < cartItems.count else { return nil }
        return cartItems[index]
    }
    
    func didIncreaseQuantity(at index: Int) {
        guard let item = cartItemAt(index) else { return }
        interactor?.increaseQuantity(productId: item.product.id)
    }
    
    func didDecreaseQuantity(at index: Int) {
        guard let item = cartItemAt(index) else { return }
        interactor?.decreaseQuantity(productId: item.product.id)
    }
    
    func didRemoveItem(at index: Int) {
        guard let item = cartItemAt(index) else { return }
        interactor?.removeItem(productId: item.product.id)
    }
    
    func didSelectProduct(at index: Int) {
        guard let item = cartItemAt(index) else { return }
        router?.navigateToProductDetail(product: item.product)
    }
    
    func getTotalPrice() -> Double {
        return cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    func clearCart() {
        interactor?.clearCart()
    }
}

// MARK: - Interactor Output
extension CartPresenter: CartInteractorOutputProtocol {
    
    func didFetchCartItems(_ items: [CartItemViewModel]) {
        cartItems = items
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            if items.isEmpty {
                self.view?.showEmptyState()
            } else {
                self.view?.hideEmptyState()
            }
            
            let totalPrice = self.getTotalPrice()
            self.view?.updateTotalPrice(totalPrice)
            self.view?.reloadData()
        }
    }
    
    func didUpdateCart() {
        // Sepet güncellendi, yeniden yükle
        interactor?.fetchCartItems()
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.showError(error.localizedDescription)
        }
    }
}

