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
    var router: ProductDetailRouterProtocol? { get set }
    
    func viewDidLoad()
    func toggleFavorite()
}

protocol ProductDetailRouterProtocol: AnyObject {
    static func createModule(with product: Product) -> UIViewController
}

