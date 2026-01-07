//
//  FeatureSectionCell.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class FeatureSectionCell: UITableViewCell {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let features = [
        (icon: "takeoutbag.and.cup.and.straw", title: "81 İLDE\nYemek", color: UIColor.systemOrange),
        (icon: "cart.fill", title: "30 DK!\nHızlı Market", color: UIColor.systemGreen),
        (icon: "star.fill", title: "2025 Trendyol\nÖzetim", color: UIColor.systemPurple),
        (icon: "gift.fill", title: "Sürpriz\n1000 TL indirim", color: UIColor.systemGreen),
        (icon: "arrow.triangle.2.circlepath", title: "Eski\nYeni", color: UIColor.systemOrange)
    ]
    
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
        collectionView.register(FeatureIconCell.self, forCellWithReuseIdentifier: "FeatureIconCell")
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
}

extension FeatureSectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureIconCell", for: indexPath) as! FeatureIconCell
        let feature = features[indexPath.item]
        cell.configure(icon: feature.icon, title: feature.title, color: feature.color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 90)
    }
}

