//
//  NetworkMonitor.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation
import Network

/// Network durumunu kontrol eden utility
/// Offline durumda kritik işlemleri (sepete ekleme, ödeme) engellemek için
class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.trendyol.networkMonitor")
    // Thread-safe erişim için
    private let accessQueue = DispatchQueue(label: "com.trendyol.networkMonitor.access")
    private var _isConnected: Bool = true
    
    private var isConnected: Bool {
        get {
            return accessQueue.sync { _isConnected }
        }
        set {
            accessQueue.sync { _isConnected = newValue }
        }
    }
    
    // URLSession configuration - Timeout ve diğer ayarlar
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5.0  // 5 saniye timeout (hızlı check için)
        configuration.timeoutIntervalForResource = 10.0  // 10 saniye resource timeout
        return URLSession(configuration: configuration)
    }()
    
    private init() {
        startMonitoring()
    }
    
    /// Network monitoring'i başlat
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    /// İnternet bağlantısı var mı kontrol et (hızlı - NWPathMonitor'dan)
    func isOnline() -> Bool {
        return isConnected
    }
    
    /// İnternet bağlantısını async olarak kontrol et
    /// Basit bir test request ile gerçek bağlantıyı doğrular
    func checkConnection() async -> Bool {
        // Önce NWPathMonitor'dan kontrol et (hızlı)
        guard isOnline() else {
            return false
        }
        
        // Gerçek bağlantıyı test et (opsiyonel - daha yavaş ama daha güvenilir)
        // Production'da bu kısmı kaldırabiliriz, sadece isOnline() kullanabiliriz
        guard let url = URL(string: "https://www.google.com") else {
            return false
        }
        
        do {
            // Timeout ile hızlı kontrol (Custom URLSession ile)
            var request = URLRequest(url: url)
            request.timeoutInterval = 2.0
            let (_, response) = try await urlSession.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                return (200...299).contains(httpResponse.statusCode)
            }
            return false
        } catch {
            return false
        }
    }
}

