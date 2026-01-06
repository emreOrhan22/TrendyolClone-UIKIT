//
//  FavoritesProtocols.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

// MARK: - View Protocol
/// View katmanı sözleşmesi - Ekranda ne görünecek?
protocol FavoritesViewProtocol: AnyObject {
    func reloadData()
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
    func showEmptyState()
    func hideEmptyState()
}

// MARK: - Presenter Protocol
/// Presenter katmanı sözleşmesi - İş mantığı koordinatörü
protocol FavoritesPresenterProtocol: AnyObject {
    var view: FavoritesViewProtocol? { get set }
    var interactor: FavoritesInteractorProtocol? { get set }
    var router: FavoritesRouterProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func numberOfProducts() -> Int
    func productAt(_ index: Int) -> Product?
    func didSelectProduct(at index: Int)
    func didRemoveFavorite(at index: Int)
}

// MARK: - Interactor Protocol
/// Interactor katmanı sözleşmesi - Veriyi kim getirecek?
protocol FavoritesInteractorProtocol: AnyObject {
    var presenter: FavoritesInteractorOutputProtocol? { get set }
    func fetchFavoriteProducts()
}

// MARK: - Interactor Output Protocol
/// Interactor çıkış sözleşmesi - Veri gelince kime haber verilecek?
protocol FavoritesInteractorOutputProtocol: AnyObject {
    func didFetchFavoriteProducts(_ products: [Product])
    func didFailWithError(_ error: Error)
}

// MARK: - Router Protocol
/// Router katmanı sözleşmesi - Modül nasıl kurulacak?
protocol FavoritesRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    var viewController: UIViewController? { get set }
    func navigateToProductDetail(product: Product)
}

