//
//  DiscoveryProtocols.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

// 1. View Sözleşmesi (Ekranda ne görünecek?)
protocol DiscoveryViewProtocol: AnyObject {
    func reloadData()
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}

// 2. Presenter Sözleşmesi (İş mantığı koordinatörü ne yapacak?)
protocol DiscoveryPresenterProtocol: AnyObject {
    var view: DiscoveryViewProtocol? { get set }
    var interactor: DiscoveryInteractorProtocol? { get set }
    var router: DiscoveryRouterProtocol? { get set }
    
    func viewDidLoad()
    func numberOfRows() -> Int
    func productAt(_ index: Int) -> Product?
    func getCategories() -> [String]
    func searchProducts(query: String)
    func filterByCategory(_ category: String)
    func didSelectProduct(at index: Int)
}

// 3. Interactor Sözleşmesi (Veriyi kim getirecek?)
protocol DiscoveryInteractorProtocol: AnyObject {
    var presenter: DiscoveryInteractorOutputProtocol? { get set }
    func fetchProducts()
    func fetchCategories()
    func fetchProductsByCategory(category: String)
}

// 4. Interactor Çıkış Sözleşmesi (Veri gelince kime haber verilecek?)
protocol DiscoveryInteractorOutputProtocol: AnyObject {
    func didFetchProducts(_ products: [Product])
    func didFetchCategories(_ categories: [String])
    func didFailWithError(_ error: Error)
}

// 5. Router Sözleşmesi (Modül nasıl kurulacak?)
protocol DiscoveryRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    var viewController: UIViewController? { get set }
    func navigateToProductDetail(product: Product)
}
