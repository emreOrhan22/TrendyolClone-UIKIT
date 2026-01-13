//
//  ImageLoader.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

/// Actor-based ImageLoader - Modern Swift 5.5+ yaklaşımı
/// Actor kullanarak thread-safety otomatik sağlanır (Data Race önlenir)
actor ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    // URLSession configuration - Timeout ve diğer ayarlar
    // Actor içinde lazy var kullanılamaz, init'te oluşturuyoruz
    private let urlSession: URLSession
    
    // Task cancellation için - hafıza yönetimi için önemli
    // Actor içinde olduğu için thread-safe (DispatchQueue'a gerek yok)
    private var runningTasks: [String: Task<UIImage?, Never>] = [:]
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
        
        // URLSession configuration - Timeout ve diğer ayarlar
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0  // 30 saniye timeout
        configuration.timeoutIntervalForResource = 60.0  // 60 saniye resource timeout
        configuration.waitsForConnectivity = true  // Bağlantı beklesin
        self.urlSession = URLSession(configuration: configuration)
    }
    
    /// Async/await ile görsel yükleme - Modern Swift yaklaşımı
    /// - Parameter urlString: Yüklenecek görselin URL'i
    /// - Returns: Yüklenen UIImage, hata durumunda nil
    func loadImage(from urlString: String) async -> UIImage? {
        // Önce cache'den kontrol et - hafıza tasarrufu için
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        
        // URL kontrolü
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        // Önceki task'ı iptal et (aynı URL için yeni istek gelirse)
        cancelTask(for: urlString)
        
        // Yeni task oluştur
        let task = Task<UIImage?, Never> {
            do {
                // Async/await ile network isteği - Custom URLSession ile timeout'lu
                let (data, _) = try await urlSession.data(from: url)
                
                // UIImage oluştur
                guard let image = UIImage(data: data) else {
                    return nil
                }
                
                // Cache'e kaydet - hafıza yönetimi için
                // Actor içinde olduğu için thread-safe
                self.cache.setObject(image, forKey: urlString as NSString)
                
                return image
            } catch {
                // Hata durumunda nil döndür
                return nil
            }
        }
        
        // Task'ı kaydet (cancellation için)
        // Actor içinde olduğu için thread-safe (DispatchQueue'a gerek yok)
        runningTasks[urlString] = task
        
        // Task'ın tamamlanmasını bekle
        let image = await task.value
        
        // Task tamamlandı, listeden çıkar
        // Actor içinde olduğu için thread-safe
        runningTasks.removeValue(forKey: urlString)
        
        return image
    }
    
    // MARK: - Task Management (Hafıza yönetimi için)
    /// Önceki task'ı iptal et - Actor içinde thread-safe
    private func cancelTask(for urlString: String) {
        if let existingTask = runningTasks[urlString] {
            existingTask.cancel()
            runningTasks.removeValue(forKey: urlString)
        }
    }
    
    /// Tüm aktif task'ları iptal et - hafıza temizliği için
    func cancelAllTasks() {
        for task in runningTasks.values {
            task.cancel()
        }
        runningTasks.removeAll()
    }
}

