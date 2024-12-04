//
//  PreviousScoresViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 24.10.24..
//

import Foundation

class PreviousScoresViewModel {
    private let userDefaultsKey = "previousScores"
    
    func savePreviousScore(mText: String, wText: String, nText: String, result: String) {
        let score = PreviousScore(mText: mText, wText: wText, nText: nText, result: result, date: Date())
        var previousScores = getPreviousScores()
        previousScores.append(score)
        
        if let encodedData = try? JSONEncoder().encode(previousScores) {
            UserDefaults.standard.setValue(encodedData, forKey: userDefaultsKey)
        }
    }
    
    func getPreviousScores() -> [PreviousScore] {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let savedScores = try? JSONDecoder().decode([PreviousScore].self, from: savedData) {
                return savedScores
            }
        }
        return []
    }
    
    func getFormattedPreviousScores() -> [(mText: String, wText: String, nText: String, result: String)] {
        let previousScores = getPreviousScores()
        return previousScores.map { score in
            return (mText: score.mText, wText: score.wText, nText: score.nText, result: score.result)
        }
    }
    
    func clearPreviousScores() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}














