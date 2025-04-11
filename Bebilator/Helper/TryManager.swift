    //
    //  TryManager.swift
    //  Bebilator
    //
    //  Created by Vladimir Savic on 25.12.24..
    //

    import Foundation

    class TryManager {
        static let shared = TryManager()
        private let remainingTriesKey = "remainingTriesKey"
        private var counterOfTapsKey = "counterOfTapsKey"
        private let maxTapsBeforeAlert = 4
      
        private(set) var remainingTries: Int {
            get {
                return UserDefaults.standard.integer(forKey: remainingTriesKey)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: remainingTriesKey)
            }
        }
        
        private(set) var counterOfTaps: Int {
            get {
               return UserDefaults.standard.integer(forKey: counterOfTapsKey)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: counterOfTapsKey)
            }
        }
        
        private init() {
            remainingTries = 1
            counterOfTaps = 2
        }
        
        var isOutOfTries: Bool {
            return remainingTries == 0 && counterOfTaps == maxTapsBeforeAlert
        }
        
        func resetRemainingTries() {
            remainingTries = 3
            counterOfTaps = 0
        }
        
        func recordTry() {
            counterOfTaps += 1
            remainingTries = max(remainingTries - 1, 0)
        }
    }
