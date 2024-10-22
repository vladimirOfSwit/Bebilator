//
//  BebilendarViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 8.10.24..
//

import Foundation
import UIKit

class BebilendarViewModel {
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    var bebilatorBrain = BebilatorBrain()
    
    var onSwitchingPeriodUpdated: (() -> Void)?
    var onValidationFailed: ((String) -> Void)?
    
    let calendar = Calendar.current
    
    func validateAndCalculateSwitchingPeriods(mBirthdateString: String?, wBirthdateString: String?, futureLimitString: String?) -> Bool {
        guard let mText = mBirthdateString, !mText.isEmpty else {
            onValidationFailed?("mTextfield is empty.")
            return false
        }
        guard bebilatorBrain.isEligible(date: mText) else {
            onValidationFailed?("mText is not eligible.")
            return false
        }
        
        guard let wText = wBirthdateString, !wText.isEmpty else {
            onValidationFailed?("wTextfield is empty.")
            return false
        }
        
        guard bebilatorBrain.isEligible(date: wText) else {
            onValidationFailed?("wText is not eligible.")
            return false
        }
        
        guard let futureLimitText = futureLimitString, !futureLimitText.isEmpty, let futureLimit = Int(futureLimitText) else {
            onValidationFailed?("Future limit is not valid.")
            return false
        }
        
        guard let mBirthdate = mText.toDate(), let wBirthdate = wText.toDate() else {
            onValidationFailed?("Invalid date format.")
            return false
        }
        
        let results = calculateSwitchingPeriods(mBirthdate: mBirthdate, wBirthdate: wBirthdate, futureLimit: futureLimit)
        for (year, month, day, gender) in results {
            print("Year: \(year), Month: \(month), Day: \(day), Gender: \(gender)")
        }
        
        switchingPeriods = results
        
        onSwitchingPeriodUpdated?()
        return true
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
    
    func showError(field: UITextField?, placeholderText: String) {
        field?.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
        field?.placeholder = placeholderText
    }
}
