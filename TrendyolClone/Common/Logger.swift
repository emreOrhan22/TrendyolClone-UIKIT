//
//  Logger.swift
//  TrendyolClone
//
//  Created by Emre ORHAN on 27.12.2025.
//

import Foundation

/// Logging seviyeleri
enum LogLevel: String {
    case debug = "🔍 DEBUG"
    case info = "ℹ️ INFO"
    case warning = "⚠️ WARNING"
    case error = "❌ ERROR"
}

/// Basit logging utility - Debug için
/// Production'da daha gelişmiş logging framework (CocoaLumberjack, etc.) kullanılabilir
struct Logger {
    
    /// Log mesajı yazdır
    /// - Parameters:
    ///   - message: Log mesajı
    ///   - level: Log seviyesi (default: .debug)
    ///   - file: Dosya adı (otomatik)
    ///   - function: Fonksiyon adı (otomatik)
    ///   - line: Satır numarası (otomatik)
    static func log(
        _ message: String,
        level: LogLevel = .debug,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let timestamp = DateFormatter.logFormatter.string(from: Date())
        print("\(timestamp) [\(level.rawValue)] \(fileName):\(line) \(function) - \(message)")
        #endif
    }
    
    /// Debug log
    static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    /// Info log
    static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    /// Warning log
    static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    /// Error log
    static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
}

