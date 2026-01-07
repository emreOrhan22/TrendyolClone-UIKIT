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
    
    // MARK: - Generic Request Method
    /// Generic network request metodu - DRY prensibi
    /// - Parameter endpoint: İstek yapılacak endpoint
    /// - Returns: Decode edilmiş response tipi
    private func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        // URL kontrolü
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        // Network isteği
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // HTTP response kontrolü
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // HTTP status code kontrolü (200-299 arası başarılı)
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        // JSON decode
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Products (Async/Await)
    /// Tüm ürünleri çeker - Modern async/await kullanır
    func fetchProducts() async throws -> [Product] {
        return try await request(endpoint: .products)
    }
    
    // MARK: - Categories (Async/Await)
    /// Tüm kategorileri çeker - Modern async/await kullanır
    func fetchCategories() async throws -> [String] {
        return try await request(endpoint: .categories)
    }
    
    // MARK: - Products by Category (Async/Await)
    /// Kategoriye göre ürünleri çeker - Modern async/await kullanır
    func fetchProductsByCategory(category: String) async throws -> [Product] {
        return try await request(endpoint: .productsByCategory(category: category))
    }
    
    // MARK: - Single Product (Async/Await)
    /// ID'ye göre tek ürün çeker - Modern async/await kullanır
    func fetchProduct(id: Int) async throws -> Product {
        return try await request(endpoint: .product(id: id))
    }
}
