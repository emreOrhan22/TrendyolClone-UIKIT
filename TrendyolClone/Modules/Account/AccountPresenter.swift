//
//  AccountPresenter.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class AccountPresenter: AccountPresenterProtocol {
    
    weak var view: AccountViewProtocol?
    var interactor: AccountInteractorProtocol?
    var router: AccountRouterProtocol?
    
    private var userName: String = ""
    private var userEmail: String = ""
    private var menuItems: [AccountMenuItem] = []
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchUserInfo()
        interactor?.fetchMenuItems()
    }
    
    func numberOfMenuItems() -> Int {
        return menuItems.count
    }
    
    func menuItemAt(_ index: Int) -> AccountMenuItem? {
        guard index >= 0 && index < menuItems.count else { return nil }
        return menuItems[index]
    }
    
    func didSelectMenuItem(at index: Int) {
        guard let menuItem = menuItemAt(index) else { return }
        
        switch menuItem.action {
        case .favorites:
            router?.navigateToFavorites()
        case .orders:
            // Siparişler ekranı (henüz yok)
            break
        case .settings:
            router?.navigateToSettings()
        case .help:
            // Yardım ekranı (henüz yok)
            break
        case .about:
            // Hakkında ekranı (henüz yok)
            break
        }
    }
    
    func getUserName() -> String {
        return userName
    }
    
    func getUserEmail() -> String {
        return userEmail
    }
}

// MARK: - Interactor Output
extension AccountPresenter: AccountInteractorOutputProtocol {
    
    func didFetchUserInfo(name: String, email: String) {
        userName = name
        userEmail = email
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.updateUserInfo(name: name, email: email)
        }
    }
    
    func didFetchMenuItems(_ items: [AccountMenuItem]) {
        menuItems = items
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
            self?.view?.showError(error.localizedDescription)
        }
    }
}

