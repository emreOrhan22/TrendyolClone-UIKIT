//
//  TestHelpers.swift
//  TrendyolCloneTests
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation
@testable import TrendyolClone

/// Test helper fonksiyonları - Test verileri oluşturma
enum TestHelpers {
    
    /// Test için örnek Product oluştur
    static func createSampleProduct(
        id: Int = 1,
        title: String = "Test Product",
        price: Double = 99.99,
        category: String = "electronics"
    ) -> Product {
        return Product(
            id: id,
            title: title,
            price: price,
            description: "Test description",
            category: category,
            image: "https://example.com/image.jpg",
            rating: Product.Rating(rate: 4.5, count: 100)
        )
    }
    
    /// Test için örnek Product array'i oluştur
    static func createSampleProducts(count: Int = 3) -> [Product] {
        return (1...count).map { index in
            createSampleProduct(
                id: index,
                title: "Product \(index)",
                price: Double(index * 10),
                category: index % 2 == 0 ? "electronics" : "clothing"
            )
        }
    }
    
    /// Test için örnek kategoriler oluştur
    static func createSampleCategories() -> [String] {
        return ["electronics", "clothing", "jewelery"]
    }
}

