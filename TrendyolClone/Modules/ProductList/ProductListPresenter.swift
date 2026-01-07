//
//  ProductListPresenter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class ProductListPresenter: ProductListPresenterProtocol {
    
    weak var view: ProductListViewProtocol?
    var interactor: ProductListInteractorProtocol?
    var router: ProductListRouterProtocol?
    
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    private var isSearching = false
    private var categories: [String] = []
    private var selectedCategory: String?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchProducts()
        interactor?.fetchCategories() // Kategorileri de çek
    }
    
    func numberOfRows() -> Int {
        return isSearching ? filteredProducts.count : products.count
    }
    
    func productAt(_ index: Int) -> Product? {
        let productList = isSearching ? filteredProducts : products
        guard index >= 0 && index < productList.count else { return nil }
        return productList[index]
    }
    
    func searchProducts(query: String) {
        // Arama mantığını sadeleştir
        let baseProducts = selectedCategory != nil ? filteredProducts : products
        
        if query.isEmpty {
            // Arama boşsa: Kategori seçiliyse filteredProducts, değilse products göster
            isSearching = selectedCategory != nil
            if !isSearching {
                filteredProducts = []
            }
        } else {
            // Arama yapılıyorsa: Base products içinde filtrele
            isSearching = true
            filteredProducts = baseProducts.filter {
                $0.title.lowercased().contains(query.lowercased())
            }
        }
        
        view?.reloadData()
    }
    
    func didSelectProduct(at index: Int) {
        guard let product = productAt(index) else { return }
        router?.navigateToProductDetail(product: product)
    }
    
    func getCategories() -> [String] {
        return categories
    }
    
    func filterByCategory(_ category: String) {
        if category == "Tümü" || category.isEmpty {
            // Tüm ürünleri göster - API'den tüm ürünleri çek
            selectedCategory = nil
            isSearching = false
            filteredProducts = []
            view?.showLoading()
            interactor?.fetchProducts() // Tüm ürünleri çek
        } else {
            // Seçilen kategoriye göre API'den ürünleri çek
            selectedCategory = category
            isSearching = true
            view?.showLoading()
            interactor?.fetchProductsByCategory(category: category) // Sadece bu kategoriye ait ürünleri çek
        }
        // reloadData burada çağrılmayacak, API'den veri geldiğinde didFetchProducts çağrılacak
    }
}

// MARK: - Interactor Output
extension ProductListPresenter: ProductListInteractorOutputProtocol {
    
    func didFetchProducts(_ products: [Product]) {
        // Eğer kategori seçiliyse, sadece o kategorinin ürünlerini göster
        if let category = selectedCategory {
            // Kategori seçiliyse, gelen ürünler zaten o kategoriye ait (API'den filtrelenmiş)
            filteredProducts = products
            isSearching = true
        } else {
            // Kategori seçili değilse, tüm ürünleri göster
            self.products = products
            isSearching = false
            filteredProducts = []
        }
        
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.reloadData()
        }
    }
    
    func didFetchCategories(_ categories: [String]) {
        self.categories = categories
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async {
            self.view?.hideLoading()
            self.view?.showError(error.localizedDescription)
        }
    }
}
