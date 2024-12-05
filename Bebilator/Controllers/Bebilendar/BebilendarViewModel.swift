//
//  BebilendarViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit

class BebilendarViewModel {
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    var bebilatorBrain = BebilatorBrain()
    var bebilendarResultControllerModel = BebilendarResultViewModel()
    let calendar = Calendar.current
    
    enum FieldType {
        case mTextfield, wTextfield, futureLimitTextfield
    }
    
    func getTheResultsForTheRequestedPeriod(mBirthdateString: String?, wBirthdateString: String?, futureLimitString: String?) -> (field: FieldType, text: String)? {
        guard let mText = mBirthdateString, !mText.isEmpty else {
            return (.mTextfield, "Polje ne može biti prazno.")
        }
        guard bebilatorBrain.isEligible(date: mText) else {
            return (.mTextfield, "Min. 18. godina")
        }
        guard let wText = wBirthdateString, !wText.isEmpty else {
            return (.wTextfield, "Polje ne može biti prazno.")
        }
        guard bebilatorBrain.isEligible(date: wText) else {
            return (.wTextfield, "Min. 18. godina")
        }
        guard let futureLimitText = futureLimitString, !futureLimitText.isEmpty, let futureLimit = Int(futureLimitText) else {
            return (.futureLimitTextfield, "Polje mora biti broj")
        }
        guard let mBirthdate = mText.toDate() else {
            return (.mTextfield, "Nevažeći format datuma.")
        }
        guard let wBirthdate = wText.toDate() else {
            return (.wTextfield, "Nevažeći format datuma.")
        }
        
        switchingPeriods = calculateSwitchingPeriods(mBirthdate: mBirthdate, wBirthdate: wBirthdate, futureLimit: futureLimit)
        
        return nil
    }
    
    func calculateSwitchingPeriods(mBirthdate: Date, wBirthdate: Date, futureLimit: Int) -> [(year: Int, month: Int, day: Int, gender: String)] {
        let currentYear  = calendar.component(.year, from: Date())
        var lastGender = ""
        
        for year in currentYear...(currentYear + futureLimit) {
            for month in 1...12 {
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = month
                
                if let monthDate = Calendar.current.date(from: dateComponents), let range = Calendar.current.range(of: .day, in: .month, for: monthDate) {
                    for day in range {
                        dateComponents.day = day
                        let yearAsDate = Calendar.current.date(from: dateComponents) ?? Date()
                        
                        let maleScore = bebilatorBrain.getDaysSinceLastAgeChange(numberOfYears: 4, bday: mBirthdate, chosenDate: yearAsDate)
                        let femaleScore = bebilatorBrain.getDaysSinceLastAgeChange(numberOfYears: 3, bday: wBirthdate, chosenDate: yearAsDate)
                        let currentGender = maleScore < femaleScore ? "boy" : "girl"
                        
                        if currentGender != lastGender {
                            switchingPeriods.append((year, month, day, currentGender))
                            lastGender = currentGender
                        }
                    }
                }
            }
        }
        return switchingPeriods
    }
}

