//
//  ImageLoader.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    // Task cancellation için - hafıza yönetimi için önemli
    private var runningTasks: [String: Task<UIImage?, Never>] = [:]
    private let taskQueue = DispatchQueue(label: "com.trendyol.imageLoader.tasks")
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
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
                // Async/await ile network isteği - closure yerine
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // UIImage oluştur
                guard let image = UIImage(data: data) else {
                    return nil
                }
                
                // Cache'e kaydet - hafıza yönetimi için
                self.cache.setObject(image, forKey: urlString as NSString)
                
                return image
            } catch {
                // Hata durumunda nil döndür
                return nil
            }
        }
        
        // Task'ı kaydet (cancellation için)
        saveTask(task, for: urlString)
        
        // Task'ın tamamlanmasını bekle
        let image = await task.value
        
        // Task tamamlandı, listeden çıkar
        removeTask(for: urlString)
        
        return image
    }
    
    // MARK: - Task Management (Hafıza yönetimi için)
    private func cancelTask(for urlString: String) {
        taskQueue.sync {
            if let existingTask = runningTasks[urlString] {
                existingTask.cancel()
                runningTasks.removeValue(forKey: urlString)
            }
        }
    }
    
    private func saveTask(_ task: Task<UIImage?, Never>, for urlString: String) {
        taskQueue.sync {
            runningTasks[urlString] = task
        }
    }
    
    private func removeTask(for urlString: String) {
        taskQueue.sync {
            runningTasks.removeValue(forKey: urlString)
        }
    }
    
    /// Tüm aktif task'ları iptal et - hafıza temizliği için
    func cancelAllTasks() {
        taskQueue.sync {
            for task in runningTasks.values {
                task.cancel()
            }
            runningTasks.removeAll()
        }
    }
}

