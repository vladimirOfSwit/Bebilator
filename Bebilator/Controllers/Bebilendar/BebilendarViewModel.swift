//
//  BebilendarViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit

enum FieldIdentifier {
    case mTextfield, wTextfield, futureLimitTextfield
}

class BebilendarViewModel {
    var switchingPeriods: [(year: Int, month: String, day: Int, gender: String)] = []
    var bebilatorBrain = BebilatorBrain()
    var bebilendarResultControllerModel = BebilendarResultViewModel()
    let calendar = Calendar.current
    var mBirthdate: Date?
    var wBirthdate: Date?
    var futureLimit: Int?
    
    func validateInputValuesFrom(mBirthdateString: String?, wBirthdateString: String?, futureLimitString: String?) -> (field: FieldIdentifier, errorText: String)? {
        func isEmpty(_ value: String?) -> Bool {
            value?.isEmpty ?? true
        }
        switch true {
        case isEmpty(mBirthdateString):
            return (.mTextfield, "Polje ne može biti prazno.")
        case !bebilatorBrain.isEligible(date: mBirthdateString ?? ""):
            return (.mTextfield, "Min. 18. godina.")
        case isEmpty(wBirthdateString):
            return (.wTextfield, "Polje ne može biti prazno.")
        case !bebilatorBrain.isEligible(date: wBirthdateString ?? ""):
            return (.wTextfield, "Min. 18. godina.")
        case isEmpty(futureLimitString), Int(futureLimitString ?? "") == nil:
            return (.futureLimitTextfield, "Polje mora biti broj")
        case mBirthdateString?.toDate() == nil:
            return (.mTextfield, "Nevažeći format datuma.")
        case wBirthdateString?.toDate() == nil:
            return (.wTextfield, "Nevažeći format datuma.")
        default:
            mBirthdate = mBirthdateString?.toDate()
            wBirthdate = wBirthdateString?.toDate()
            futureLimit = Int(futureLimitString ?? "")
            return nil
        }
    }
    
    func getTheFinalResult() {
        
        guard let mBirthdate = mBirthdate,
              let wBirthdate = wBirthdate,
              let futureLimit = futureLimit else {
            print("Validation failed. Cannot calculate results.")
            return
        }
        
        switchingPeriods = calculateSwitchingPeriods(mBirthdate: mBirthdate, wBirthdate: wBirthdate, futureLimit: futureLimit)
    }
    
    func calculateSwitchingPeriods(mBirthdate: Date, wBirthdate: Date, futureLimit: Int) -> [(year: Int, month: String, day: Int, gender: String)] {
        switchingPeriods = []
        let currentYear  = calendar.component(.year, from: Date())
        let monthsInSerbian: [String: Int] = [
            "Januar": 1, "Februar": 2, "Mart": 3, "April": 4, "Maj": 5, "Jun": 6, "Jul": 7, "Avgust": 8, "Septembar": 9, "Oktobar": 10, "Novembar": 11, "Decembar": 12]
        var lastGender = ""
        
        for year in currentYear...(currentYear + futureLimit) {
            for (monthName, monthNumber) in monthsInSerbian {
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = monthNumber
                
                if let monthDate = Calendar.current.date(from: dateComponents), let range = Calendar.current.range(of: .day, in: .month, for: monthDate) {
                    for day in range {
                        dateComponents.day = day
                        let yearAsDate = Calendar.current.date(from: dateComponents) ?? Date()
                        
                        let maleScore = bebilatorBrain.getDaysSinceLastAgeChange(numberOfYears: 4, bday: mBirthdate, chosenDate: yearAsDate)
                        let femaleScore = bebilatorBrain.getDaysSinceLastAgeChange(numberOfYears: 3, bday: wBirthdate, chosenDate: yearAsDate)
                        let currentGender = maleScore < femaleScore ? "boy" : "girl"
                        
                        if currentGender != lastGender {
                            switchingPeriods.append((year, monthName, day, currentGender))
                            lastGender = currentGender
                        }
                    }
                }
            }
        }
        return switchingPeriods
    }
}

