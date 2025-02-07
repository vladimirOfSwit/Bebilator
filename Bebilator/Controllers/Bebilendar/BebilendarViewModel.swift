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
    var switchingPeriods: [SwitchingPeriod] = []
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
    
    func calculateSwitchingPeriods(mBirthdate: Date, wBirthdate: Date, futureLimit: Int) -> [SwitchingPeriod] {
        switchingPeriods = []
        let currentYear  = calendar.component(.year, from: Date())
        var lastGender: Gender? = nil
        
        for year in currentYear...(currentYear + futureLimit) {
            print(year)
            for (monthNumber, monthName) in Constants.monthsInSerbian {
                print("Processing month \(monthNumber): \(monthName)")
                var dateComponents = DateComponents()
                dateComponents.year = year
                dateComponents.month = monthNumber
                
                if let monthDate = Calendar.current.date(from: dateComponents), let range = Calendar.current.range(of: .day, in: .month, for: monthDate) {
                    for day in range {
                        dateComponents.day = day
                        let yearAsDate = Calendar.current.date(from: dateComponents) ?? Date()
                        
                        let maleScore = bebilatorBrain.getDaysSinceLastAgeChange(numberOfYears: 4, bday: mBirthdate, chosenDate: yearAsDate)
                        print("Year as date for male score is: \(yearAsDate)")
                        
                        
                        let femaleScore = bebilatorBrain.getDaysSinceLastAgeChange(numberOfYears: 3, bday: wBirthdate, chosenDate: yearAsDate)
                        print("Year as date for female score is: \(yearAsDate)")
                      
                        let currentGender = maleScore < femaleScore ? Gender.boy : Gender.girl
                            
                        print("Male score is: \(maleScore)")
                        print("Female score is: \(femaleScore)")
                        
                        print("Current gender is: \(currentGender)")
                        print("Month number is \(monthNumber)")
                        if currentGender != lastGender {
                            let switchingPeriod = SwitchingPeriod(year: year,
                                                                  month: monthNumber,
                                                                  day: day,
                                                                  gender: currentGender
                            )
                            switchingPeriods.append(switchingPeriod)
                            lastGender = currentGender
                           
                        }
                    }
                }
            }
            
            switchingPeriods.sort {
                if $0.year == $1.year {
                    if $0.month == $1.month {
                        return $0.day < $1.day
                    }
                    return $0.month < $1.month
                }
                return $0.year < $1.year
            }
            
        }
        return switchingPeriods
       
    }
}

