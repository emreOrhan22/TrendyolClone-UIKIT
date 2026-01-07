//
//  DiscoveryHeaderView.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class DiscoveryHeaderView: UIView {
    
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemOrange
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let bannerLabel: UILabel = {
        let label = UILabel()
        label.text = "TRENDYOL CLONE"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(bannerImageView)
        bannerImageView.addSubview(bannerLabel)
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 150),
            bannerImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            bannerLabel.centerXAnchor.constraint(equalTo: bannerImageView.centerXAnchor),
            bannerLabel.centerYAnchor.constraint(equalTo: bannerImageView.centerYAnchor)
        ])
    }
}

