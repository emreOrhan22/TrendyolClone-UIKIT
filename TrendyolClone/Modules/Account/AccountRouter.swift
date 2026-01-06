//
//  AccountRouter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class AccountRouter: AccountRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = AccountViewController()
        let presenter = AccountPresenter()
        let interactor = AccountInteractor()
        let router = AccountRouter()
        
        // Katmanları birbirine "enjekte" ediyoruz (Dependency Injection)
        view.presenter = presenter
        router.viewController = view
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToFavorites() {
        // Tab bar'da Favoriler sekmesine geç
        if let tabBarController = viewController?.tabBarController {
            tabBarController.selectedIndex = 1 // Favoriler sekmesi
        }
    }
    
    func navigateToSettings() {
        // Ayarlar ekranı (henüz yok, placeholder alert)
        let alert = UIAlertController(title: "Ayarlar", message: "Ayarlar özelliği yakında eklenecek!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        viewController?.present(alert, animated: true)
    }
}

