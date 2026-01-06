//
//  LocalizationHelper.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

final class LocalizationHelper {
    
    static let shared = LocalizationHelper()
    
    private init() {}
    
    // Kategori isimlerini İngilizce'den Türkçe'ye çevir
    func localizedCategory(_ category: String) -> String {
        let categoryMap: [String: String] = [
            "men's clothing": "Erkek Giyim",
            "women's clothing": "Kadın Giyim",
            "electronics": "Elektronik",
            "jewelry": "Mücevher"
        ]
        
        // Önce tam eşleşme kontrol et
        if let turkishName = categoryMap[category.lowercased()] {
            return turkishName
        }
        
        // Eğer eşleşme yoksa, kategori ismini capitalize et ve döndür
        return category.capitalized
    }
    
    // Tüm kategorileri Türkçeleştir
    func localizedCategories(_ categories: [String]) -> [String] {
        return categories.map { localizedCategory($0) }
    }
}

