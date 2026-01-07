//
//  ProductListViewController.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class ProductListViewController: UIViewController, ProductListViewProtocol {
    
    var presenter: ProductListPresenterProtocol?
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Trendyol Clone"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Dark mode'u override et, her zaman beyaz olsun
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        // Search Bar
        setupSearchBar()
        
        // Loading Indicator
        setupLoadingIndicator()
        
        // TableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.register(CategorySectionCell.self, forCellReuseIdentifier: "CategorySectionCell")
        tableView.register(BannerSectionCell.self, forCellReuseIdentifier: "BannerSectionCell")
        tableView.register(FeatureSectionCell.self, forCellReuseIdentifier: "FeatureSectionCell")
        tableView.register(ProductHorizontalSectionCell.self, forCellReuseIdentifier: "ProductHorizontalSectionCell")
        
        // Pull to Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshProducts), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Ürün ara..."
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = .systemOrange
        loadingIndicator.hidesWhenStopped = true
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func refreshProducts() {
        presenter?.viewDidLoad()
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource
extension ProductListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // Kategoriler + Banner + Özellikler + Yatay Ürünler
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Her section'da 1 satır
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Kategoriler
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategorySectionCell", for: indexPath) as! CategorySectionCell
            // Kategorileri Presenter'dan al ve göster
            let allCategories = ["Tümü"] + (presenter?.getCategories() ?? [])
            cell.categories = allCategories
            cell.onCategorySelected = { [weak self] category in
                self?.presenter?.filterByCategory(category)
            }
            return cell
        } else if indexPath.section == 1 {
            // Banner
            let cell = tableView.dequeueReusableCell(withIdentifier: "BannerSectionCell", for: indexPath) as! BannerSectionCell
            return cell
        } else if indexPath.section == 2 {
            // Özellikler
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeatureSectionCell", for: indexPath) as! FeatureSectionCell
            return cell
        } else {
            // Yatay Ürünler
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductHorizontalSectionCell", for: indexPath) as! ProductHorizontalSectionCell
            
            // Index-based erişim - View Product bilgisine sahip olmamalı
            cell.numberOfProducts = { [weak self] in
                self?.presenter?.numberOfRows() ?? 0
            }
            
            cell.productAt = { [weak self] index in
                self?.presenter?.productAt(index)
            }
            
            cell.onProductSelected = { [weak self] index in
                self?.presenter?.didSelectProduct(at: index)
            }
            
            // CollectionView'ı yenile
            cell.reloadCollectionView()
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension ProductListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Ürün tıklamaları zaten ProductHorizontalSectionCell içindeki 
        // CollectionView'dan closure (onProductSelected) ile yönetiliyor.
        // Burada indexPath.row kullanmak yanlış çünkü:
        // - Section 0: Kategoriler (ürün değil)
        // - Section 1: Banner (ürün değil)
        // - Section 2: Özellikler (ürün değil)
        // - Section 3: Yatay Ürünler (zaten cell.onProductSelected ile yönetiliyor)
        // Bu yüzden burada hiçbir işlem yapmıyoruz.
    }
}

// MARK: - UISearchResultsUpdating
extension ProductListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        presenter?.searchProducts(query: searchText)
    }
}
