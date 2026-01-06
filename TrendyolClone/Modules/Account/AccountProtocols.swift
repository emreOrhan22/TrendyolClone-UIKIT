//
//  AccountProtocols.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

/// Hesap menü öğesi
struct AccountMenuItem {
    let title: String
    let icon: String
    let action: AccountMenuAction
}

enum AccountMenuAction {
    case favorites
    case orders
    case settings
    case help
    case about
}

// MARK: - View Protocol
/// View katmanı sözleşmesi - Ekranda ne görünecek?
protocol AccountViewProtocol: AnyObject {
    func reloadData()
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
    func updateUserInfo(name: String, email: String)
}

// MARK: - Presenter Protocol
/// Presenter katmanı sözleşmesi - İş mantığı koordinatörü
protocol AccountPresenterProtocol: AnyObject {
    var view: AccountViewProtocol? { get set }
    var interactor: AccountInteractorProtocol? { get set }
    var router: AccountRouterProtocol? { get set }
    
    func viewDidLoad()
    func numberOfMenuItems() -> Int
    func menuItemAt(_ index: Int) -> AccountMenuItem?
    func didSelectMenuItem(at index: Int)
    func getUserName() -> String
    func getUserEmail() -> String
}

// MARK: - Interactor Protocol
/// Interactor katmanı sözleşmesi - Veriyi kim getirecek?
protocol AccountInteractorProtocol: AnyObject {
    var presenter: AccountInteractorOutputProtocol? { get set }
    func fetchUserInfo()
    func fetchMenuItems()
}

// MARK: - Interactor Output Protocol
/// Interactor çıkış sözleşmesi - Veri gelince kime haber verilecek?
protocol AccountInteractorOutputProtocol: AnyObject {
    func didFetchUserInfo(name: String, email: String)
    func didFetchMenuItems(_ items: [AccountMenuItem])
    func didFailWithError(_ error: Error)
}

// MARK: - Router Protocol
/// Router katmanı sözleşmesi - Modül nasıl kurulacak?
protocol AccountRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    var viewController: UIViewController? { get set }
    func navigateToFavorites()
    func navigateToSettings()
}

