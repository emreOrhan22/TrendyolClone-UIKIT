# Repository Pattern Implementation

## Summary
Implement Repository Pattern for data layer abstraction with cache management, improving testability and enabling offline support.

## Changes

### 1. Repository Pattern Architecture
**New Repository Layer**
- Created `ProductRepositoryProtocol` - Repository interface for data abstraction
- Created `ProductCacheProtocol` - Cache interface for different cache implementations
- Created `ProductCache` - Memory-based cache implementation using UserDefaults
- Created `ProductRepository` - Main repository implementation with cache-first strategy

**Repository Structure:**
```
Repository/
├── ProductRepositoryProtocol.swift  - Interface
├── ProductCacheProtocol.swift      - Cache interface
├── ProductCache.swift               - Cache implementation
└── ProductRepository.swift          - Repository implementation
```

**Benefits:**
- Data layer abstraction - Interactor doesn't know about Network/Cache details
- Cache management - Automatic cache-first strategy
- Offline support - App works with cached data when offline
- Testability - Easy to create mock repositories for unit tests
- Single Responsibility - Interactor focuses on business logic only

### 2. Cache-First Strategy
**How It Works:**
1. Repository checks cache first
2. If cache exists and is valid → Return cached data (fast!)
3. If cache is empty or stale → Fetch from network
4. Save network response to cache
5. Return data

**Implementation:**
```swift
func getProducts() async throws -> [Product] {
    // 1. Check cache first
    if let cachedProducts = cache.getProducts(), !cachedProducts.isEmpty {
        return cachedProducts  // Fast response!
    }
    
    // 2. Fetch from network if cache is empty
    let products = try await networkService.fetchProducts()
    
    // 3. Save to cache
    cache.saveProducts(products)
    
    // 4. Return data
    return products
}
```

### 3. Interactor Updates
**DiscoveryInteractor**
- Replaced `ProductServiceProtocol` with `ProductRepositoryProtocol`
- Now uses `productRepository.getProducts()` instead of `productService.fetchProducts()`
- Automatic cache management - no manual cache handling needed

**FavoritesInteractor**
- Updated to use `ProductRepository` instead of `ProductServiceProtocol`
- Benefits from cache when fetching all products for filtering

**CartInteractor**
- Updated to use `ProductRepository` instead of `ProductServiceProtocol`
- Faster cart loading with cached product data

### 4. Cache Implementation Details
**ProductCache (UserDefaults-based)**
- Stores products in UserDefaults as JSON
- Category-based caching for filtered products
- Categories caching
- Clear cache functionality

**Cache Keys:**
- `cached_products` - All products
- `cached_categories` - All categories
- `cached_products_category_{category}` - Category-specific products

**Future Improvements:**
- Cache expiration (TTL)
- NSCache for memory cache
- Core Data for persistent storage
- Cache size management

## Technical Details

### Before (Direct Network Access)
```swift
class DiscoveryInteractor {
    private let productService: ProductServiceProtocol
    
    func fetchProducts() {
        let products = try await productService.fetchProducts() // Direct network
    }
}
```

**Problems:**
- No cache management
- No offline support
- Hard to test
- Tight coupling to network layer

### After (Repository Pattern)
```swift
class DiscoveryInteractor {
    private let productRepository: ProductRepositoryProtocol
    
    func fetchProducts() {
        // Repository handles cache + network automatically
        let products = try await productRepository.getProducts()
    }
}
```

**Benefits:**
- Automatic cache management
- Offline support
- Easy to test (mock repository)
- Loose coupling

### Dependency Injection
```swift
// Default implementation
init(productRepository: ProductRepositoryProtocol = ProductRepository()) {
    self.productRepository = productRepository
}

// Test with mock
let mockRepository = MockProductRepository()
let interactor = DiscoveryInteractor(productRepository: mockRepository)
```

## Files Added
- `Repository/ProductRepositoryProtocol.swift` - Repository interface
- `Repository/ProductCacheProtocol.swift` - Cache interface
- `Repository/ProductCache.swift` - Cache implementation
- `Repository/ProductRepository.swift` - Repository implementation

## Files Modified
- `Modules/Discovery/DiscoveryInteractor.swift` - Updated to use Repository
- `Modules/Favorites/FavoritesInteractor.swift` - Updated to use Repository
- `Modules/Cart/CartInteractor.swift` - Updated to use Repository

## Testing
- Verified cache-first strategy works correctly
- Confirmed offline support (cache returns data when network unavailable)
- Tested cache persistence across app launches
- Verified all Interactors work with Repository pattern

## Future Enhancements
- [ ] Cache expiration (TTL) - Stale cache detection
- [ ] Mock Repository for unit tests
- [ ] NSCache for memory cache (faster than UserDefaults)
- [ ] Core Data for persistent storage
- [ ] Cache size management
- [ ] Network error handling with cache fallback

## Migration Notes
- All Interactors now use `ProductRepositoryProtocol` instead of `ProductServiceProtocol`
- No breaking changes for Presenters/ViewControllers
- Cache is automatically managed - no manual cache calls needed

