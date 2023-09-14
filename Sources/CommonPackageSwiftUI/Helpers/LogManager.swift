//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import Foundation
import XCGLogger

let log = XCGLogger.default

public struct LogManager {
    
    static var logsDir: String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsPath + "/.logs"
    }
    
    public static func setup(configuration: BuildConfiguration) {
        var level: XCGLogger.Level = .none
        switch configuration.environment {
        case .debugDev, .debugStag, .debugPro:
            level = .debug
        case .releaseStag:
            level = .debug
        case .releasePro:
            level = .none
        case .releaseDev:
            level = .none
        }
        log.setup(level: level, showLogIdentifier: false,
                  showFunctionName: false, showThreadName: false,
                  showLevel: true, showFileNames: true,
                  showLineNumbers: true, showDate: false)
        if FileManager.default.fileExists(atPath: Self.logsDir) == false {
            do {
                try FileManager.default.createDirectory(atPath: Self.logsDir, withIntermediateDirectories: true)
            } catch let error {
                log.alert("Cannot create directory for writing log files: \(error.localizedDescription)")
                return
            }
        }
        
        let fileDestination = AutoRotatingFileDestination(owner: log,
                                                          writeToFile: "\(Self.logsDir)/app.log",
                                                          identifier: "advancedLogger.fileDestination",
                                                          shouldAppend: true,
                                                          appendMarker: "New Session",
                                                          attributes: nil,
                                                          maxFileSize: 10024000,
                                                          maxTimeInterval: 900,
                                                          archiveSuffixDateFormatter: nil,
                                                          targetMaxLogFiles: 250)

        // Optionally set some configuration options
        fileDestination.outputLevel = level
        fileDestination.showLogIdentifier = false
        fileDestination.showFunctionName = false
        fileDestination.showThreadName = false
        fileDestination.showLevel = false
        fileDestination.showFileName = true
        fileDestination.showLineNumber = true
        fileDestination.showDate = true
        
        
        let emojiLogFormatter = PrePostFixLogFormatter()
        emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", to: .error)
        log.formatters = [emojiLogFormatter]
        
        fileDestination.logQueue = XCGLogger.logQueue
        
        // Add the destination to the logger
        log.add(destination: fileDestination)
    }

    static func logFilesPath(complete: ([String]) -> ()) {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: Self.logsDir)
            complete(files.map{ "\(Self.logsDir)/\($0)"})
        } catch {
            complete([])
        }
    }

    static func clean(complete: ((Error?) -> ())?) {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: Self.logsDir)
            try files.forEach { file in
                try FileManager.default.removeItem(atPath: "\(Self.logsDir)/\(file)")
            }
            complete?(nil)
        } catch let error {
            complete?(error)
        }
    }
}
