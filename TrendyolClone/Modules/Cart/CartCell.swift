//
//  CartCell.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class CartCell: UITableViewCell {
    
    var onIncreaseQuantity: (() -> Void)?
    var onDecreaseQuantity: (() -> Void)?
    var onRemove: (() -> Void)?
    
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
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        decreaseButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(decreaseButton)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(increaseButton)
        contentView.addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            // Product Image
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),
            
            // Price
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            
            // Quantity Controls
            decreaseButton.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            decreaseButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            decreaseButton.widthAnchor.constraint(equalToConstant: 30),
            decreaseButton.heightAnchor.constraint(equalToConstant: 30),
            decreaseButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            quantityLabel.centerYAnchor.constraint(equalTo: decreaseButton.centerYAnchor),
            quantityLabel.leadingAnchor.constraint(equalTo: decreaseButton.trailingAnchor, constant: 8),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            
            increaseButton.centerYAnchor.constraint(equalTo: decreaseButton.centerYAnchor),
            increaseButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 8),
            increaseButton.widthAnchor.constraint(equalToConstant: 30),
            increaseButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Remove Button
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configuration
    func configure(with item: CartItemViewModel) {
        titleLabel.text = item.product.title
        priceLabel.text = String(format: "%.2f TL", item.totalPrice)
        quantityLabel.text = "\(item.quantity)"
        
        // Görseli yükle - Async/await ile
        productImageView.image = nil
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            let image = await ImageLoader.shared.loadImage(from: item.product.image)
            self.productImageView.image = image
        }
    }
    
    // MARK: - Actions
    @objc private func decreaseButtonTapped() {
        onDecreaseQuantity?()
    }
    
    @objc private func increaseButtonTapped() {
        onIncreaseQuantity?()
    }
    
    @objc private func removeButtonTapped() {
        onRemove?()
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        quantityLabel.text = nil
    }
}

