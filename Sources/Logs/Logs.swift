//
//  Logs.swift
//  OpenBudget
//
//  Created by Khan Winter on 2/16/21.
//  Copyright © 2021 Windchillmedia. All rights reserved.
//

import Foundation
#if !targetEnvironment(macCatalyst) && canImport(FirebaseCrashlytics)
import FirebaseCrashlytics
#endif
import os.log

extension OSLog {
    fileprivate static var subsystem = Bundle.main.bundleIdentifier!
}

public enum LogLevel {
    case info
    case debug
    case warning
    case error
    case crash
}

public struct Log {
    public static var `default`: LogCategory = LogCategory("Default")
    public static var viewCycle: LogCategory = LogCategory("View Cycle")
    public static var dataManager: LogCategory = LogCategory("Data Manager")
    public static var api: LogCategory = LogCategory("API Client")
    
    public class LogCategory {
        // Category Name
        private var category: String
        
        // Init
        public init(_ category: String) {
            self.category = category
        }
        
        // Underlying Logger instance
        private var logger: OSLog {
            get {
                return OSLog(subsystem: OSLog.subsystem, category: category)
            }
        }
        
        // Logging Levels
        public func log(_ str: String, level: LogLevel = .info) {
            Log.log(str, level: level, logger: logger)
        }
        
        public func info(_ str: String) {
            Log.log(str, level: .info, logger: logger)
        }
        
        public func debug(_ str: String) {
            Log.log(str, level: .debug, logger: logger)
        }
        
        public func warning(_ str: String) {
            Log.log(str, level: .warning, logger: logger)
        }
        
        public func error(_ str: String) {
            Log.log(str, level: .error, logger: logger)
        }
        
        public func crash(_ str: String) {
            Log.log(str, level: .crash, logger: logger)
        }
    }
    
    // Log the thing
    public static func log(_ str: String, level: LogLevel = .info, logger: OSLog? = nil) {
        let osLog: OSLog
        if logger == nil {
            osLog = OSLog(subsystem: OSLog.subsystem, category: "Default")
        } else {
            osLog = logger!
        }
        switch level {
        case .info:
            os_log("%{public}@", log: osLog, type: .info, str)
        case .debug:
            os_log("%{public}@", log: osLog, type: .debug, str)
        case .warning:
            os_log("%{public}@", log: osLog, type: .error, str)
        case .error:
            os_log("%{public}@", log: osLog, type: .error, str)
        case .crash:
            os_log("%{public}@", log: osLog, type: .fault, str)
        }
        
        #if !targetEnvironment(macCatalyst) && canImport(FirebaseCrashlytics)
        if level == .crash {
            let userInfo = [
                NSLocalizedDescriptionKey: NSLocalizedString(str, comment: ""),
            ]
            
            let error = NSError.init(domain: NSCocoaErrorDomain,
                                     code: -69,
                                     userInfo: userInfo)
            Crashlytics.crashlytics().record(error: error)
        } else {
            Crashlytics.crashlytics().log(str)
        }
        #endif
    }
}
