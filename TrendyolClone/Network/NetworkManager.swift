//
//  NetworkManager.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

// MARK: - Network Error
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError(Error)
    case httpError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidResponse:
            return "Geçersiz yanıt"
        case .invalidData:
            return "Geçersiz veri"
        case .decodingError(let error):
            return "Veri çözümleme hatası: \(error.localizedDescription)"
        case .httpError(let code):
            return "HTTP hatası: \(code)"
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Products (Async/Await)
    /// Tüm ürünleri çeker - Modern async/await kullanır
    func fetchProducts() async throws -> [Product] {
        let urlString = "https://fakestoreapi.com/products"
        
        // URL kontrolü - hata varsa throw ediyoruz (silent fail yerine)
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // async/await ile network isteği - closure yerine direkt await
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // HTTP response kontrolü
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // HTTP status code kontrolü (200-299 arası başarılı)
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        // JSON decode - hata varsa throw ediyoruz
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Categories (Async/Await)
    /// Tüm kategorileri çeker - Modern async/await kullanır
    func fetchCategories() async throws -> [String] {
        let urlString = "https://fakestoreapi.com/products/categories"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        do {
            let categories = try JSONDecoder().decode([String].self, from: data)
            return categories
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Products by Category (Async/Await)
    /// Kategoriye göre ürünleri çeker - Modern async/await kullanır
    func fetchProductsByCategory(category: String) async throws -> [Product] {
        // URL encoding - özel karakterler için güvenli
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? category
        let urlString = "https://fakestoreapi.com/products/category/\(encodedCategory)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        do {
            let products = try JSONDecoder().decode([Product].self, from: data)
            return products
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Single Product (Async/Await)
    /// ID'ye göre tek ürün çeker - Modern async/await kullanır
    func fetchProduct(id: Int) async throws -> Product {
        let urlString = "https://fakestoreapi.com/products/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        do {
            let product = try JSONDecoder().decode(Product.self, from: data)
            return product
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
