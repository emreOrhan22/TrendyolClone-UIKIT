//
//  ProductDetailPresenter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class ProductDetailPresenter: ProductDetailPresenterProtocol {
    
    weak var view: ProductDetailViewProtocol?
    var interactor: ProductDetailInteractorProtocol?
    var router: ProductDetailRouterProtocol?
    
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    func viewDidLoad() {
        // Ürün bilgilerini göster
        view?.showProduct(product)
        
        // Favori durumunu Interactor'dan kontrol et
        interactor?.checkFavoriteStatus(productId: product.id)
    }
    
    func toggleFavorite() {
        // Favori durumunu Interactor üzerinden değiştir
        interactor?.toggleFavorite(productId: product.id)
    }
}

// MARK: - Interactor Output
extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
    
    func didCheckFavoriteStatus(isFavorite: Bool) {
        // Favori durumu kontrol edildi, View'ı güncelle
        view?.updateFavoriteButton(isFavorite: isFavorite)
    }
    
    func didToggleFavorite(isFavorite: Bool) {
        // Favori durumu değiştirildi, View'ı güncelle
        view?.updateFavoriteButton(isFavorite: isFavorite)
    }
}

