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
            return "Geçersiz URL. Lütfen daha sonra tekrar deneyin."
        case .invalidResponse:
            return "Sunucudan geçersiz yanıt alındı. Lütfen daha sonra tekrar deneyin."
        case .invalidData:
            return "Veri alınamadı. Lütfen daha sonra tekrar deneyin."
        case .decodingError:
            return "Veri işlenirken bir hata oluştu. Lütfen daha sonra tekrar deneyin."
        case .httpError(let code):
            switch code {
            case 400:
                return "Geçersiz istek. Lütfen tekrar deneyin."
            case 401:
                return "Yetkilendirme hatası. Lütfen tekrar giriş yapın."
            case 403:
                return "Erişim reddedildi. Lütfen daha sonra tekrar deneyin."
            case 404:
                return "İstenen içerik bulunamadı."
            case 429:
                return "Çok fazla istek gönderildi. Lütfen bir süre sonra tekrar deneyin."
            case 500...599:
                return "Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin."
            default:
                return "Bir hata oluştu (Kod: \(code)). Lütfen daha sonra tekrar deneyin."
            }
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    // URLSession configuration - Timeout ve diğer ayarlar
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0  // 30 saniye timeout
        configuration.timeoutIntervalForResource = 60.0  // 60 saniye resource timeout
        configuration.waitsForConnectivity = true  // Bağlantı beklesin
        return URLSession(configuration: configuration)
    }()
    
    private init() {}
    
    // MARK: - Retry Configuration
    private let maxRetryAttempts = 3
    private let baseDelay: TimeInterval = 1.0  // 1 saniye başlangıç delay
    
    // MARK: - Generic Request Method with Retry
    /// Generic network request metodu - DRY prensibi + Exponential Backoff Retry
    /// - Parameter endpoint: İstek yapılacak endpoint
    /// - Returns: Decode edilmiş response tipi
    private func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        var lastError: Error?
        
        // Exponential backoff ile retry (3 deneme)
        for attempt in 0..<maxRetryAttempts {
            do {
                return try await performRequest(endpoint: endpoint)
            } catch {
                lastError = error
                
                // Son denemede hata varsa throw et
                if attempt == maxRetryAttempts - 1 {
                    throw error
                }
                
                // Exponential backoff: 1s, 2s, 4s
                let delay = baseDelay * pow(2.0, Double(attempt))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        
        // Buraya gelmemeli ama compiler için
        throw lastError ?? NetworkError.invalidResponse
    }
    
    // MARK: - Single Request Attempt
    /// Tek bir network isteği yapar (retry olmadan)
    private func performRequest<T: Decodable>(endpoint: Endpoint) async throws -> T {
        // URL kontrolü
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        // Network isteği - Custom URLSession ile timeout'lu
        let (data, response) = try await urlSession.data(from: url)
        
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
