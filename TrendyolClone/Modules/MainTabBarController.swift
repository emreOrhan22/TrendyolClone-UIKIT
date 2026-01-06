//
//  MainTabBarController.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // Ana Sayfa
        let productListVC = ProductListRouter.createModule()
        let homeNav = UINavigationController(rootViewController: productListVC)
        homeNav.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        // Favoriler - VIPER modülü
        let favoritesVC = FavoritesRouter.createModule()
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorilerim", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        // Sepet (placeholder)
        let cartVC = UIViewController()
        cartVC.view.backgroundColor = .white
        cartVC.title = "Sepetim"
        let cartNav = UINavigationController(rootViewController: cartVC)
        cartNav.tabBarItem = UITabBarItem(title: "Sepetim", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        
        // Hesabım (placeholder)
        let accountVC = UIViewController()
        accountVC.view.backgroundColor = .white
        accountVC.title = "Hesabım"
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
}

