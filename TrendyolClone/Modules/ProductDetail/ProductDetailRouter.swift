//
//  ProductDetailRouter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class ProductDetailRouter: ProductDetailRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(with product: Product) -> UIViewController {
        let view = ProductDetailViewController()
        let presenter = ProductDetailPresenter(product: product)
        let interactor = ProductDetailInteractor()
        let router = ProductDetailRouter()
        
        // Katmanları birbirine "enjekte" ediyoruz (Dependency Injection)
        view.presenter = presenter
        router.viewController = view
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        return view
    }
}

