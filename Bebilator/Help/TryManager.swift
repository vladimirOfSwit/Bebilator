    //
    //  TryManager.swift
    //  Bebilator
    //
    //  Created by Vladimir Savic on 25.12.24..
    //

    import Foundation

    class TryManager {
        static let shared = TryManager()
        let maxTries = 3
        
        private init() {}
        
        private let counterKey = "counter"
        private let purchasedTriesKey = "purchasedTries"
      
        
        var counter: Int {
            get {
                return UserDefaults.standard.integer(forKey: counterKey)
            }
            set {
                return UserDefaults.standard.set(newValue, forKey: counterKey)
            }
        }
        
        var purchasedTries: Int {
            get {
                UserDefaults.standard.integer(forKey: purchasedTriesKey)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: purchasedTriesKey)
            }
        }
        var remainingTries: Int {
            let totalTries = maxTries + purchasedTries
            return max(0, totalTries - counter)
        }
    }
