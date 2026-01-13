//
//  ProductRepositoryTests.swift
//  TrendyolCloneTests
//
//  Created by Emre ORHAN on 27.12.2025.
//

import XCTest
@testable import TrendyolClone

/// ProductRepository için Unit Testler
/// 
/// Test Senaryoları:
/// 1. Cache'den veri çekme (başarılı)
/// 2. Network'ten veri çekme (cache yoksa)
/// 3. Cache + Network kombinasyonu
/// 4. Error handling (network hatası)
/// 5. Offline fallback (network hatası, cache varsa)
final class ProductRepositoryTests: XCTestCase {
    
    var repository: ProductRepository!
    var mockNetworkService: MockProductService!
    var mockCache: MockProductCache!
    
    // Her test öncesi çalışır
    override func setUp() {
        super.setUp()
        mockNetworkService = MockProductService()
        mockCache = MockProductCache()
        repository = ProductRepository(
            networkService: mockNetworkService,
            cache: mockCache
        )
    }
    
    // Her test sonrası çalışır
    override func tearDown() {
        repository = nil
        mockNetworkService = nil
        mockCache = nil
        super.tearDown()
    }
    
    // MARK: - Cache Tests
    
    /// Test: Cache'den veri çekme (başarılı)
    func testGetProducts_FromCache_Success() async throws {
        // Given: Cache'de veri var
        let cachedProducts = TestHelpers.createSampleProducts(count: 2)
        mockCache.saveProducts(cachedProducts)
        
        // When: Ürünleri çek
        let products = try await repository.getProducts()
        
        // Then: Cache'den döndürmeli, network'e gitmemeli
        XCTAssertEqual(products.count, 2)
        XCTAssertEqual(mockNetworkService.fetchProductsCallCount, 0, "Network'e gitmemeli")
        XCTAssertEqual(products.first?.id, cachedProducts.first?.id)
    }
    
    /// Test: Cache boşsa network'ten çekme
    func testGetProducts_FromNetwork_WhenCacheEmpty() async throws {
        // Given: Cache boş, network'te veri var
        let networkProducts = TestHelpers.createSampleProducts(count: 3)
        mockNetworkService.productsToReturn = networkProducts
        
        // When: Ürünleri çek
        let products = try await repository.getProducts()
        
        // Then: Network'ten çekmeli ve cache'e kaydetmeli
        XCTAssertEqual(products.count, 3)
        XCTAssertEqual(mockNetworkService.fetchProductsCallCount, 1, "Network'e gitmeli")
        
        // Cache'e kaydedilmiş mi kontrol et
        let cachedProducts = mockCache.getProducts()
        XCTAssertNotNil(cachedProducts)
        XCTAssertEqual(cachedProducts?.count, 3)
    }
    
    // MARK: - Error Handling Tests
    
    /// Test: Network hatası, cache yoksa hata fırlatmalı
    func testGetProducts_NetworkError_NoCache_ThrowsError() async {
        // Given: Network hatası, cache boş
        mockNetworkService.shouldFail = true
        mockNetworkService.failError = NetworkError.httpError(500)
        
        // When/Then: Hata fırlatmalı
        do {
            _ = try await repository.getProducts()
            XCTFail("Hata fırlatılmalıydı")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    /// Test: Network hatası, cache varsa cache'den döndürmeli (offline support)
    func testGetProducts_NetworkError_WithCache_ReturnsCache() async throws {
        // Given: Network hatası, ama cache'de veri var
        let cachedProducts = TestHelpers.createSampleProducts(count: 2)
        mockCache.saveProducts(cachedProducts)
        mockNetworkService.shouldFail = true
        mockNetworkService.failError = NetworkError.httpError(500)
        
        // When: Ürünleri çek
        let products = try await repository.getProducts()
        
        // Then: Cache'den döndürmeli (offline support)
        XCTAssertEqual(products.count, 2)
        XCTAssertEqual(products.first?.id, cachedProducts.first?.id)
    }
    
    // MARK: - Category Tests
    
    /// Test: Kategoriye göre ürün çekme (cache'den)
    func testGetProductsByCategory_FromCache() async throws {
        // Given: Cache'de kategoriye göre veri var
        let category = "electronics"
        let categoryProducts = TestHelpers.createSampleProducts(count: 2)
        mockCache.saveProducts(categoryProducts, for: category)
        
        // When: Kategoriye göre ürünleri çek
        let products = try await repository.getProductsByCategory(category)
        
        // Then: Cache'den döndürmeli
        XCTAssertEqual(products.count, 2)
        XCTAssertEqual(mockNetworkService.fetchProductsByCategoryCallCount, 0)
    }
    
    /// Test: Kategoriye göre ürün çekme (network'ten)
    func testGetProductsByCategory_FromNetwork() async throws {
        // Given: Cache boş, network'te veri var
        let category = "electronics"
        let networkProducts = TestHelpers.createSampleProducts(count: 3)
        mockNetworkService.productsToReturn = networkProducts
        
        // When: Kategoriye göre ürünleri çek
        _ = try await repository.getProductsByCategory(category)
        
        // Then: Network'ten çekmeli ve cache'e kaydetmeli
        XCTAssertEqual(mockNetworkService.fetchProductsByCategoryCallCount, 1)
        let cachedProducts = mockCache.getProducts(for: category)
        XCTAssertNotNil(cachedProducts)
    }
    
    // MARK: - Categories Tests
    
    /// Test: Kategorileri çekme (cache'den)
    func testGetCategories_FromCache() async throws {
        // Given: Cache'de kategoriler var
        let categories = TestHelpers.createSampleCategories()
        mockCache.saveCategories(categories)
        
        // When: Kategorileri çek
        let result = try await repository.getCategories()
        
        // Then: Cache'den döndürmeli
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(mockNetworkService.fetchCategoriesCallCount, 0)
    }
    
    /// Test: Kategorileri çekme (network'ten)
    func testGetCategories_FromNetwork() async throws {
        // Given: Cache boş, network'te kategoriler var
        let categories = TestHelpers.createSampleCategories()
        mockNetworkService.categoriesToReturn = categories
        
        // When: Kategorileri çek
        let result = try await repository.getCategories()
        
        // Then: Network'ten çekmeli ve cache'e kaydetmeli
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(mockNetworkService.fetchCategoriesCallCount, 1)
        let cachedCategories = mockCache.getCategories()
        XCTAssertNotNil(cachedCategories)
    }
    
    // MARK: - Clear Cache Tests
    
    /// Test: Cache temizleme
    func testClearCache() {
        // Given: Cache'de veri var
        let products = TestHelpers.createSampleProducts()
        mockCache.saveProducts(products)
        
        // When: Cache'i temizle
        repository.clearCache()
        
        // Then: Cache temizlenmeli
        XCTAssertEqual(mockCache.clearCallCount, 1)
        XCTAssertNil(mockCache.getProducts())
    }
}

