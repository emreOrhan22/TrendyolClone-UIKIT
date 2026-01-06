//
//  ProductDetailRouter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class ProductDetailRouter: ProductDetailRouterProtocol {
    
    static func createModule(with product: Product) -> UIViewController {
        let view = ProductDetailViewController()
        let presenter = ProductDetailPresenter(product: product)
        let router = ProductDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return view
    }
}

