//
//  AccountInteractor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

class AccountInteractor: AccountInteractorProtocol {
    
    weak var presenter: AccountInteractorOutputProtocol?
    
    func fetchUserInfo() {
        // Şimdilik mock kullanıcı bilgileri
        // Gerçek uygulamada API'den çekilebilir
        Task { @MainActor [weak self] in
            // Simüle edilmiş kullanıcı bilgileri
            let userName = "Kullanıcı"
            let userEmail = "kullanici@example.com"
            self?.presenter?.didFetchUserInfo(name: userName, email: userEmail)
        }
    }
    
    func fetchMenuItems() {
        // Menü öğelerini oluştur
        let menuItems: [AccountMenuItem] = [
            AccountMenuItem(title: "Favorilerim", icon: "heart.fill", action: .favorites),
            AccountMenuItem(title: "Siparişlerim", icon: "bag.fill", action: .orders),
            AccountMenuItem(title: "Ayarlar", icon: "gearshape.fill", action: .settings),
            AccountMenuItem(title: "Yardım & Destek", icon: "questionmark.circle.fill", action: .help),
            AccountMenuItem(title: "Hakkında", icon: "info.circle.fill", action: .about)
        ]
        
        Task { @MainActor [weak self] in
            self?.presenter?.didFetchMenuItems(menuItems)
        }
    }
}

