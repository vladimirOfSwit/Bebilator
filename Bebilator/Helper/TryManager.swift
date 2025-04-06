    //
    //  TryManager.swift
    //  Bebilator
    //
    //  Created by Vladimir Savic on 25.12.24..
    //

    import Foundation

    class TryManager {
        static let shared = TryManager()
        
        private init() {}
        
        private let remainingTriesKey = "remainingTriesKey"
      
        var remainingTries: Int {
            get {
                UserDefaults.standard.integer(forKey: remainingTriesKey)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: remainingTriesKey)
            }
        }
        
        func resetRemainingTries() {
            remainingTries = 3
        }
        
        func useTry() {
            if remainingTries > 0 {
                remainingTries -= 1
            }
        }
        
        var isOutOfTries: Bool {
            remainingTries == 0
        }
    }
