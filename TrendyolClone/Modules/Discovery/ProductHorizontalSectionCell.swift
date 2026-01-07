//
//  ProductHorizontalSectionCell.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class ProductHorizontalSectionCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sana Özel Ürünler"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tümü >", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemOrange, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // Index-based erişim - View Product bilgisine sahip olmamalı
    var numberOfProducts: (() -> Int)? {
        didSet {
            collectionView.reloadData()
        }
    }
    var productAt: ((Int) -> Product?)?
    var onProductSelected: ((Int) -> Void)?
    
    /// CollectionView'ı yenile - Dışarıdan erişim için
    func reloadCollectionView() {
        collectionView.reloadData()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductHorizontalCell.self, forCellWithReuseIdentifier: "ProductHorizontalCell")
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(seeAllButton)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 280),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

extension ProductHorizontalSectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfProducts?() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHorizontalCell", for: indexPath) as! ProductHorizontalCell
        
        if let product = productAt?(indexPath.item) {
            cell.configure(with: product)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onProductSelected?(indexPath.item)
    }
}

class ProductHorizontalCell: UICollectionViewCell {
    
    private let productImageView = UIImageView()
    private let badgeLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    var onFavoriteTapped: ((Int) -> Void)?
    private var productId: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        productImageView.backgroundColor = .lightGray
        productImageView.layer.cornerRadius = 8
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        badgeLabel.text = "SON 14 GÜNÜN EN DÜŞÜK FİYATI"
        badgeLabel.font = .systemFont(ofSize: 8, weight: .bold)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 4
        badgeLabel.clipsToBounds = true
        badgeLabel.numberOfLines = 0
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .systemOrange
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 15
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        priceLabel.textColor = .systemOrange
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(productImageView)
        contentView.addSubview(badgeLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImageView.heightAnchor.constraint(equalToConstant: 160),
            
            badgeLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 4),
            badgeLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 4),
            badgeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            favoriteButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 4),
            favoriteButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -4),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28),
            favoriteButton.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with product: Product) {
        productId = product.id
        titleLabel.text = product.title
        priceLabel.text = String(format: "%.2f TL", product.price)
        
        // Async/await ile görsel yükleme
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            let image = await ImageLoader.shared.loadImage(from: product.image)
            self.productImageView.image = image
        }
        
        // Favori durumunu güncelle (Actor'a await ile erişim)
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            let isFavorite = await FavoriteManager.shared.isFavorite(productId: product.id)
            self.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
        }
    }
    
    @objc private func favoriteButtonTapped() {
        guard let productId = productId else { return }
        // Actor'a await ile erişim
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            await FavoriteManager.shared.toggleFavorite(productId: productId)
            let isFavorite = await FavoriteManager.shared.isFavorite(productId: productId)
            self.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
            self.onFavoriteTapped?(productId)
        }
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        productId = nil
        onFavoriteTapped = nil
    }
}

