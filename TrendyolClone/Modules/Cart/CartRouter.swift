//
//  CartRouter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class CartRouter: CartRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(
        repository: ProductRepositoryProtocol = ProductRepository()
    ) -> UIViewController {
        let view = CartViewController()
        let presenter = CartPresenter()
        let interactor = CartInteractor(productRepository: repository)
        let router = CartRouter()
        
        // Katmanları birbirine "enjekte" ediyoruz (Dependency Injection)
        view.presenter = presenter
        router.viewController = view
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToProductDetail(product: Product) {
        let productDetailVC = ProductDetailRouter.createModule(with: product)
        viewController?.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

