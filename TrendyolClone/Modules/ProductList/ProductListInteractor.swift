//
//  ProductListInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class ProductListInteractor: ProductListInteractorProtocol {
    
    weak var presenter: ProductListInteractorOutputProtocol?
    
    func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.presenter?.didFetchProducts(products)
            case .failure(let error):
                self?.presenter?.didFailWithError(error)
            }
        }
    }
    
    func fetchCategories() {
        NetworkManager.shared.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.presenter?.didFetchCategories(categories)
            case .failure(let error):
                self?.presenter?.didFailWithError(error)
            }
        }
    }
    
    func fetchProductsByCategory(category: String) {
        NetworkManager.shared.fetchProductsByCategory(category: category) { [weak self] result in
            switch result {
            case .success(let products):
                self?.presenter?.didFetchProducts(products)
            case .failure(let error):
                self?.presenter?.didFailWithError(error)
            }
        }
    }
}
