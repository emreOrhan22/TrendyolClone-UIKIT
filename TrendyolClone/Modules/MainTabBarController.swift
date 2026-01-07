//
//  MainTabBarController.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var cartTabBarItem: UITabBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        updateCartBadge()
        
        // Sepet değiştiğinde badge'i güncelle
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCartBadge),
            name: NSNotification.Name("CartDidUpdate"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartBadge()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupTabBar() {
        // Ana Sayfa (Discovery)
        let discoveryVC = DiscoveryRouter.createModule()
        let homeNav = UINavigationController(rootViewController: discoveryVC)
        homeNav.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        // Favoriler - VIPER modülü
        let favoritesVC = FavoritesRouter.createModule()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorilerim", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        // Sepet - VIPER modülü
        let cartVC = CartRouter.createModule()
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(title: "Sepetim", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        cartTabBarItem = cartNav.tabBarItem
        
        // Hesabım - VIPER modülü
        let accountVC = AccountRouter.createModule()
        let accountNav = UINavigationController(rootViewController: accountVC)
        accountNav.tabBarItem = UITabBarItem(title: "Hesabım", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        viewControllers = [homeNav, favoritesNav, cartNav, accountNav]
        
        // Tab Bar görünümü
        tabBar.tintColor = .systemOrange
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }
    }
    
    // MARK: - Badge Update
    @objc private func updateCartBadge() {
        // Actor'a await ile erişim (Task içinde)
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            let cartItemCount = await CartManager.shared.getTotalItemCount()
            
            if cartItemCount > 0 {
                self.cartTabBarItem?.badgeValue = "\(cartItemCount)"
                self.cartTabBarItem?.badgeColor = .systemOrange
            } else {
                self.cartTabBarItem?.badgeValue = nil
            }
        }
    }
}

