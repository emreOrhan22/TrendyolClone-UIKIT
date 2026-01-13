//
//  ProductDetailViewController.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class ProductDetailViewController: UIViewController, ProductDetailViewProtocol {
    
    var presenter: ProductDetailPresenterProtocol?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let categoryLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let addToCartButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Memory warning geldiğinde image cache'ini temizle
        Task {
            await ImageLoader.shared.cancelAllTasks()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Navigation Bar
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        // Favorite Button
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemOrange
        favoriteButton.accessibilityLabel = "Favorilere ekle"
        favoriteButton.accessibilityHint = "Çift dokunarak ürünü favorilere ekleyebilir veya çıkarabilirsiniz"
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        
        // ScrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Product Image
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.backgroundColor = .lightGray
        productImageView.layer.cornerRadius = 12
        contentView.addSubview(productImageView)
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Price
        priceLabel.font = .systemFont(ofSize: 24, weight: .bold)
        priceLabel.textColor = .systemOrange
        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Category
        categoryLabel.font = .systemFont(ofSize: 14, weight: .medium)
        categoryLabel.textColor = .gray
        contentView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Description
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to Cart Button
        addToCartButton.setTitle("Sepete Ekle", for: .normal)
        addToCartButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.backgroundColor = .systemOrange
        addToCartButton.layer.cornerRadius = 12
        addToCartButton.accessibilityLabel = "Sepete ekle"
        addToCartButton.accessibilityHint = "Çift dokunarak ürünü sepete ekleyebilirsiniz"
        addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        contentView.addSubview(addToCartButton)
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Product Image
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Price
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Category
            categoryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Add to Cart Button
            addToCartButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func favoriteButtonTapped() {
        presenter?.toggleFavorite()
    }
    
    @objc private func addToCartButtonTapped() {
        // Sepete ekleme işlemi Presenter üzerinden yapılıyor
        // Network kontrolü Interactor'da yapılıyor
        presenter?.addToCart()
    }
    
    // MARK: - ProductDetailViewProtocol
    func showProduct(_ product: Product) {
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = product.title
            self?.priceLabel.text = String(format: "%.2f TL", product.price)
            // Kategoriyi Türkçeleştir
            self?.categoryLabel.text = LocalizationHelper.shared.localizedCategory(product.category).uppercased()
            self?.descriptionLabel.text = product.description
        }
        
        // Async/await ile görsel yükleme - Modern Swift yaklaşımı
        // Placeholder göster (resim yüklenirken boş görünmesin)
        productImageView.image = UIImage(systemName: "photo")
        productImageView.contentMode = .center
        productImageView.tintColor = .systemGray3
        
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            let image = await ImageLoader.shared.loadImage(from: product.image)
            // Resim yüklendiğinde veya hata durumunda
            if let loadedImage = image {
                self.productImageView.image = loadedImage
                self.productImageView.contentMode = .scaleAspectFill
            } else {
                // Hata durumunda fallback placeholder
                self.productImageView.image = UIImage(systemName: "photo.artframe")
                self.productImageView.contentMode = .center
                self.productImageView.tintColor = .systemGray3
            }
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func showSuccess(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Başarılı", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        DispatchQueue.main.async { [weak self] in
            let imageName = isFavorite ? "heart.fill" : "heart"
            self?.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
            // Accessibility güncelle
            self?.favoriteButton.accessibilityLabel = isFavorite ? "Favorilerden çıkar" : "Favorilere ekle"
        }
    }
}

