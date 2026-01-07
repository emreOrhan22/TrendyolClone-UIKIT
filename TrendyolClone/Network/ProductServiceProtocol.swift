//
//  ProductServiceProtocol.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Ürün servisi protokolü - Test edilebilirlik için
protocol ProductServiceProtocol {
    func fetchProducts() async throws -> [Product]
    func fetchProduct(id: Int) async throws -> Product
    func fetchCategories() async throws -> [String]
    func fetchProductsByCategory(category: String) async throws -> [Product]
}

/// NetworkManager'ı ProductServiceProtocol'e uyumlu hale getir
extension NetworkManager: ProductServiceProtocol {}

