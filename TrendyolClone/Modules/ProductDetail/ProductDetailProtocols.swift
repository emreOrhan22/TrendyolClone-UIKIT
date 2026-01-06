//
//  ProductDetailProtocols.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

protocol ProductDetailViewProtocol: AnyObject {
    func showProduct(_ product: Product)
    func showError(_ message: String)
    func updateFavoriteButton(isFavorite: Bool)
}

protocol ProductDetailPresenterProtocol: AnyObject {
    var view: ProductDetailViewProtocol? { get set }
    var interactor: ProductDetailInteractorProtocol? { get set }
    var router: ProductDetailRouterProtocol? { get set }
    
    func viewDidLoad()
    func toggleFavorite()
    func addToCart()
}

// MARK: - Interactor Protocol
/// Interactor katmanı sözleşmesi - Veriyi kim getirecek?
protocol ProductDetailInteractorProtocol: AnyObject {
    var presenter: ProductDetailInteractorOutputProtocol? { get set }
    func checkFavoriteStatus(productId: Int)
    func toggleFavorite(productId: Int)
    func addToCart(productId: Int)
}

// MARK: - Interactor Output Protocol
/// Interactor çıkış sözleşmesi - Veri gelince kime haber verilecek?
protocol ProductDetailInteractorOutputProtocol: AnyObject {
    func didCheckFavoriteStatus(isFavorite: Bool)
    func didToggleFavorite(isFavorite: Bool)
    func didAddToCart()
}

protocol ProductDetailRouterProtocol: AnyObject {
    static func createModule(with product: Product) -> UIViewController
    var viewController: UIViewController? { get set }
}

