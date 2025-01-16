//
//  PreviousScoresViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 24.10.24..
//

import Foundation

class PreviousScoresViewModel {
    private let userDefaultsKey = "previousScores"
    
    func savePreviousScore(mText: String, wText: String, nText: String, gender: Gender) {
        let score = PreviousScore(mTextfieldValue: mText, wTextfieldValue: wText, nTextfieldValue: nText, gender: gender, date: Date())
        var allScores = getPreviousScores()
        if allScores.contains(where: {
            $0.mTextfieldValue == score.mTextfieldValue &&
            $0.wTextfieldValue == score.wTextfieldValue &&
            $0.nTextfieldValue == score.nTextfieldValue &&
            $0.gender == score.gender
        }) {
            print("Score alreday exists")
            return
        }
        
        allScores.append(score)
        
        if let encodedData = try? JSONEncoder().encode(allScores) {
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
    
    func getFormattedPreviousScores() -> [PreviousScore] {
       return getPreviousScores()
    }
    
    func clearPreviousScores() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}














