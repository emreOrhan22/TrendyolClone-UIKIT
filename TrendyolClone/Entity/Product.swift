import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating?
    
    struct Rating: Decodable {
        let rate: Double
        let count: Int
    }
}

