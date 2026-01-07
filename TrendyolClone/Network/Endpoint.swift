//
//  Endpoint.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// API endpoint'lerini merkezi yönetir
enum Endpoint {
    case products
    case product(id: Int)
    case categories
    case productsByCategory(category: String)
    
    /// Base URL - Tek bir yerden yönetilir
    private var baseURL: String {
        return "https://fakestoreapi.com"
    }
    
    /// Endpoint path'i
    private var path: String {
        switch self {
        case .products:
            return "/products"
        case .product(let id):
            return "/products/\(id)"
        case .categories:
            return "/products/categories"
        case .productsByCategory(let category):
            // URL encoding - özel karakterler için güvenli
            let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? category
            return "/products/category/\(encodedCategory)"
        }
    }
    
    /// Tam URL'i döndürür
    var url: URL? {
        return URL(string: baseURL + path)
    }
}

