import Foundation

/// Ürün modeli - Codable (hem Encodable hem Decodable)
/// Encodable: Cache'e kaydetmek için gerekli
/// Decodable: Network'ten gelen JSON'u parse etmek için gerekli
struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating?
    
    struct Rating: Codable {
        let rate: Double
        let count: Int
    }
}

