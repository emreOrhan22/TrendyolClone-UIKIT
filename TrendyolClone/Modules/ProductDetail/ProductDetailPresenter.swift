//
//  ProductDetailPresenter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class ProductDetailPresenter: ProductDetailPresenterProtocol {
    
    weak var view: ProductDetailViewProtocol?
    var router: ProductDetailRouterProtocol?
    
    private let product: Product
    private var isFavorite = false
    
    init(product: Product) {
        self.product = product
    }
    
    func viewDidLoad() {
        view?.showProduct(product)
        isFavorite = FavoriteManager.shared.isFavorite(productId: product.id)
        view?.updateFavoriteButton(isFavorite: isFavorite)
    }
    
    func toggleFavorite() {
        FavoriteManager.shared.toggleFavorite(productId: product.id)
        isFavorite = FavoriteManager.shared.isFavorite(productId: product.id)
        view?.updateFavoriteButton(isFavorite: isFavorite)
    }
}

