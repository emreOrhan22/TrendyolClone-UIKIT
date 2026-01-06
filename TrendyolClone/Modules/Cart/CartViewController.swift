//
//  CartViewController.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class CartViewController: UIViewController, CartViewProtocol {
    
    var presenter: CartPresenterProtocol?
    
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    // Bottom View - Toplam fiyat ve ödeme butonu
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .systemOrange
        label.text = "0.00 TL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ödeme Yap", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clearCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sepeti Temizle", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Empty State View
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cart")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Sepetiniz boş"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Her ekran göründüğünde sepeti yenile
        presenter?.viewWillAppear()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Sepetim"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Navigation Bar görünümü
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        // Loading Indicator
        setupLoadingIndicator()
        
        // Empty State View
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Bottom View - ÖNCE EKLE (TableView constraint'i buna bağlı)
        setupBottomView()
        
        // TableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        
        // Pull to Refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCart), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupBottomView() {
        view.addSubview(bottomView)
        
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
        clearCartButton.addTarget(self, action: #selector(clearCartButtonTapped), for: .touchUpInside)
        
        bottomView.addSubview(totalPriceLabel)
        bottomView.addSubview(checkoutButton)
        bottomView.addSubview(clearCartButton)
        
        NSLayoutConstraint.activate([
            // Bottom View
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Clear Cart Button
            clearCartButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 8),
            clearCartButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            
            // Total Price Label
            totalPriceLabel.topAnchor.constraint(equalTo: clearCartButton.bottomAnchor, constant: 8),
            totalPriceLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            totalPriceLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            
            // Checkout Button
            checkoutButton.centerYAnchor.constraint(equalTo: totalPriceLabel.centerYAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            checkoutButton.leadingAnchor.constraint(equalTo: totalPriceLabel.trailingAnchor, constant: 16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
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
    
    @objc private func refreshCart() {
        presenter?.viewWillAppear()
    }
    
    @objc private func checkoutButtonTapped() {
        let alert = UIAlertController(title: "Ödeme", message: "Ödeme özelliği yakında eklenecek!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func clearCartButtonTapped() {
        let alert = UIAlertController(title: "Sepeti Temizle", message: "Sepetinizdeki tüm ürünler silinecek. Emin misiniz?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        alert.addAction(UIAlertAction(title: "Temizle", style: .destructive) { [weak self] _ in
            self?.presenter?.clearCart()
        })
        present(alert, animated: true)
    }
    
    // MARK: - CartViewProtocol
    func reloadData() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func showEmptyState() {
        emptyStateView.isHidden = false
        tableView.isHidden = true
        bottomView.isHidden = true
    }
    
    func hideEmptyState() {
        emptyStateView.isHidden = true
        tableView.isHidden = false
        bottomView.isHidden = false
    }
    
    func updateTotalPrice(_ total: Double) {
        totalPriceLabel.text = String(format: "Toplam: %.2f TL", total)
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        if let item = presenter?.cartItemAt(indexPath.row) {
            cell.configure(with: item)
            
            cell.onIncreaseQuantity = { [weak self] in
                self?.presenter?.didIncreaseQuantity(at: indexPath.row)
            }
            
            cell.onDecreaseQuantity = { [weak self] in
                self?.presenter?.didDecreaseQuantity(at: indexPath.row)
            }
            
            cell.onRemove = { [weak self] in
                self?.presenter?.didRemoveItem(at: indexPath.row)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectProduct(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

