//
//  CartProtocols.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

/// Sepet öğesi - View için (Product + Quantity)
struct CartItemViewModel {
    let product: Product
    let quantity: Int
    var totalPrice: Double {
        return product.price * Double(quantity)
    }
}

// MARK: - View Protocol
/// View katmanı sözleşmesi - Ekranda ne görünecek?
protocol CartViewProtocol: AnyObject {
    func reloadData()
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
    func showEmptyState()
    func hideEmptyState()
    func updateTotalPrice(_ total: Double)
}

// MARK: - Presenter Protocol
/// Presenter katmanı sözleşmesi - İş mantığı koordinatörü
protocol CartPresenterProtocol: AnyObject {
    var view: CartViewProtocol? { get set }
    var interactor: CartInteractorProtocol? { get set }
    var router: CartRouterProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func numberOfItems() -> Int
    func cartItemAt(_ index: Int) -> CartItemViewModel?
    func didIncreaseQuantity(at index: Int)
    func didDecreaseQuantity(at index: Int)
    func didRemoveItem(at index: Int)
    func didSelectProduct(at index: Int)
    func getTotalPrice() -> Double
    func clearCart()
}

// MARK: - Interactor Protocol
/// Interactor katmanı sözleşmesi - Veriyi kim getirecek?
protocol CartInteractorProtocol: AnyObject {
    var presenter: CartInteractorOutputProtocol? { get set }
    func fetchCartItems()
    func increaseQuantity(productId: Int)
    func decreaseQuantity(productId: Int)
    func removeItem(productId: Int)
    func clearCart()
}

// MARK: - Interactor Output Protocol
/// Interactor çıkış sözleşmesi - Veri gelince kime haber verilecek?
protocol CartInteractorOutputProtocol: AnyObject {
    func didFetchCartItems(_ items: [CartItemViewModel])
    func didUpdateCart()
    func didFailWithError(_ error: Error)
}

// MARK: - Router Protocol
/// Router katmanı sözleşmesi - Modül nasıl kurulacak?
protocol CartRouterProtocol: AnyObject {
    static func createModule(repository: ProductRepositoryProtocol) -> UIViewController
    var viewController: UIViewController? { get set }
    func navigateToProductDetail(product: Product)
}

// Protocol Extension - Default değer için
extension CartRouterProtocol {
    static func createModule() -> UIViewController {
        return createModule(repository: ProductRepository())
    }
}

