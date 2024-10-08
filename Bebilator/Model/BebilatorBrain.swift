//
//  BebilatorBrain.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.11.23..
//

import Foundation
import UIKit


struct BebilatorBrain {
    
    var chosenDateAsString: String = ""
    var finalResult = ""
    let calendar = Calendar.current
    
    public mutating func getDifferenceInAgingAndCalculateFinalResult(m: String, w: String, dateToConcieve: String) {
        
        var scoreMale = 0
        var scoreFemale = 0
        
        guard let mBdayAsDate = formatStringToDate(date: m) else { return }
        guard let wBdayAsDate = formatStringToDate(date: w) else { return }
        guard let chosenDateAsDate = formatStringToDate(date: dateToConcieve) else { return }
        
        scoreMale = getDaysSinceLastAgeChange(numberOfYears: 4, bday: mBdayAsDate, chosenDate: chosenDateAsDate)
        scoreFemale = getDaysSinceLastAgeChange(numberOfYears: 3, bday: wBdayAsDate, chosenDate: chosenDateAsDate)
        
        finalResult = calculateGender(scoreM: scoreMale, scoreW: scoreFemale)
    }
    
    func getDaysSinceLastAgeChange(numberOfYears: Int, bday: Date, chosenDate: Date) -> Int {
        
        var bdayCalculatedByAddingYears = bday
        var resultsOfAging: [Date] = []
        var latestChageDate: Date?
        
        //Accumulate the aging dates
        repeat {
            bdayCalculatedByAddingYears = bdayCalculatedByAddingYears.addYear(n: numberOfYears)
            resultsOfAging.append(bdayCalculatedByAddingYears)
            
            if bdayCalculatedByAddingYears > chosenDate {
                resultsOfAging.removeLast()
                latestChageDate = resultsOfAging.last
                break
            }
        } while bdayCalculatedByAddingYears <= chosenDate
        
        guard let lastChange = latestChageDate else {
            print("No latest date found")
            return 0
        }
        
        let timeInterval = calendar.dateComponents([.day], from: lastChange, to: chosenDate)
        let daysPassedSinceChange = (timeInterval.day ?? 0) + 100
        
        return daysPassedSinceChange
        
    }
    
    func formatStringToDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.date(from: date)
    }
    
    func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
    
    public func calculateGender(scoreM: Int, scoreW: Int) -> String {
        if scoreM < scoreW {
            return("boy")
        } else {
            return("girl")
        }
    }
    
    func isEligible (date: String) -> Bool {
        guard let bDay = formatStringToDate(date: date) else { return false }
        guard let eighteenYearsAgoFromToday = calendar.date(byAdding: .year, value: -18, to: Date()) else {
            return false
        }
        return bDay <= eighteenYearsAgoFromToday
    }
    
    func validateTextField(_ textField: UITextField, placeHolderEmpty: String, placeholderNotEligible: String) -> Bool {
        guard let text = textField.text, !text.isEmpty, text != K.TEXTFIELD_PLACEHOLDER else {
            textField.text = ""
            textField.placeholder = placeHolderEmpty
            textField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 6, revert: true)
            return false
        }
        
        if !isEligible(date: text) {
            textField.text = ""
            textField.placeholder = placeholderNotEligible
            textField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 6, revert: true)
            return false
        }
        return true
    }
}
