//
//  FavoritesPresenter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class FavoritesPresenter: FavoritesPresenterProtocol {
    
    weak var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorProtocol?
    var router: FavoritesRouterProtocol?
    
    private var favoriteProducts: [Product] = []
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchFavoriteProducts()
    }
    
    func viewWillAppear() {
        // Her ekran göründüğünde favorileri yenile
        // (Başka ekrandan favori eklenip çıkarılmış olabilir)
        view?.showLoading()
        interactor?.fetchFavoriteProducts()
    }
    
    func numberOfProducts() -> Int {
        return favoriteProducts.count
    }
    
    func productAt(_ index: Int) -> Product? {
        guard index >= 0 && index < favoriteProducts.count else { return nil }
        return favoriteProducts[index]
    }
    
    func didSelectProduct(at index: Int) {
        guard let product = productAt(index) else { return }
        router?.navigateToProductDetail(product: product)
    }
    
    func didRemoveFavorite(at index: Int) {
        guard let product = productAt(index) else { return }
        FavoriteManager.shared.removeFavorite(productId: product.id)
        // Favorileri yenile
        viewWillAppear()
    }
}

// MARK: - Interactor Output
extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    
    func didFetchFavoriteProducts(_ products: [Product]) {
        favoriteProducts = products
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            if products.isEmpty {
                self.view?.showEmptyState()
            } else {
                self.view?.hideEmptyState()
            }
            
            self.view?.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.showError(error.localizedDescription)
        }
    }
}

