//
//  ProductCell.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class ProductCell: UITableViewCell {
    
    var onFavoriteTapped: ((Int) -> Void)?
    private var productId: Int?
    
    // MARK: - UI Components
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = "SON 14 GÜNÜN EN DÜŞÜK FİYATI"
        label.font = .systemFont(ofSize: 9, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .systemRed
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemOrange
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Rating için StackView (5 yıldız + sayı)
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        // 5 yıldız oluştur (boş yıldızlar, sonra doldurulacak)
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star")
            starImageView.tintColor = .systemGray3
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
            ratingStackView.addArrangedSubview(starImageView)
        }
        
        // Rating count label'ı StackView'a ekle
        ratingStackView.addArrangedSubview(ratingCountLabel)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(badgeLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            // Product Image
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            
            // Badge
            badgeLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8),
            badgeLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 8),
            badgeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            
            // Favorite Button
            favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Rating (yıldızlar + sayı)
            ratingStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // Price
            priceLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    func configure(with product: Product) {
        productId = product.id
        titleLabel.text = product.title
        priceLabel.text = String(format: "%.2f TL", product.price)
        
        // Accessibility (VoiceOver) desteği
        isAccessibilityElement = true
        accessibilityLabel = "\(product.title), Fiyat: \(String(format: "%.2f TL", product.price))"
        accessibilityHint = "Çift dokunarak ürün detaylarını görüntüleyebilirsiniz"
        
        favoriteButton.accessibilityLabel = "Favorilere ekle"
        favoriteButton.accessibilityHint = "Çift dokunarak ürünü favorilere ekleyebilir veya çıkarabilirsiniz"
        
        productImageView.isAccessibilityElement = false  // Decorative image
        
        // Görseli yükle - Async/await ile
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
        
        // Rating göster
        if let rating = product.rating {
            updateRating(rate: rating.rate, count: rating.count)
        } else {
            // Rating yoksa gizle
            ratingStackView.isHidden = true
        }
        
        // Favori durumunu güncelle (Actor'a await ile erişim)
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            let isFavorite = await FavoriteManager.shared.isFavorite(productId: product.id)
            self.updateFavoriteButton(isFavorite: isFavorite)
            
            // Accessibility güncelle
            self.favoriteButton.accessibilityLabel = isFavorite ? "Favorilerden çıkar" : "Favorilere ekle"
        }
        
        // Badge'i göster/gizle (şimdilik her zaman göster)
        badgeLabel.isHidden = false
    }
    
    // Rating'e göre yıldızları doldur
    private func updateRating(rate: Double, count: Int) {
        ratingStackView.isHidden = false
        
        // StackView'daki ilk 5 eleman yıldızlar
        for (index, arrangedSubview) in ratingStackView.arrangedSubviews.enumerated() {
            if index < 5, let starImageView = arrangedSubview as? UIImageView {
                // Eğer index, rating'den küçükse dolu yıldız
                if Double(index) < rate {
                    starImageView.image = UIImage(systemName: "star.fill")
                    starImageView.tintColor = .systemYellow
                } else {
                    starImageView.image = UIImage(systemName: "star")
                    starImageView.tintColor = .systemGray3
                }
            }
        }
        
        // Son eleman rating count label
        ratingCountLabel.text = "(\(count))"
    }
    
    @objc private func favoriteButtonTapped() {
        guard let productId = productId else { return }
        // Actor'a await ile erişim
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            await FavoriteManager.shared.toggleFavorite(productId: productId)
            let isFavorite = await FavoriteManager.shared.isFavorite(productId: productId)
            self.updateFavoriteButton(isFavorite: isFavorite)
            self.onFavoriteTapped?(productId)
        }
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        ratingStackView.isHidden = false
        ratingCountLabel.text = nil
    }
}

