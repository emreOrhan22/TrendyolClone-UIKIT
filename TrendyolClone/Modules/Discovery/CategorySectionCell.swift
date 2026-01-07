//
//  CategorySectionCell.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

class CategorySectionCell: UITableViewCell {
    
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
    
    var categories: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var selectedIndex = 0
    var onCategorySelected: ((String) -> Void)?
    
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
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 56) // 2 satır için daha yüksek
        ])
    }
}

extension CategorySectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categories[indexPath.item]
        // "Tümü" zaten Türkçe, diğerlerini Türkçeleştir
        let displayName = category == "Tümü" ? category : LocalizationHelper.shared.localizedCategory(category)
        cell.configure(title: displayName, isSelected: indexPath.item == selectedIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.item < categories.count else { return CGSize(width: 100, height: 56) }
        let category = categories[indexPath.item]
        // Türkçeleştirilmiş ismi kullan (genişlik hesaplaması için)
        let displayName = category == "Tümü" ? category : LocalizationHelper.shared.localizedCategory(category)
        
        // Metin genişliğini hesapla (2 satır için maksimum genişlik)
        let maxWidth: CGFloat = 200 // Maksimum genişlik
        let textWidth = displayName.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width
        let padding: CGFloat = 32 // 16 + 16 (leading + trailing)
        let calculatedWidth = min(textWidth + padding, maxWidth)
        let finalWidth = max(calculatedWidth, 80) // Minimum genişlik
        
        return CGSize(width: finalWidth, height: 56) // 2 satır için yükseklik
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        let category = categories[indexPath.item]
        onCategorySelected?(category)
    }
}

