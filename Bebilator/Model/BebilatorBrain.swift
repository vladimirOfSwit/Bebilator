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
        
        guard let mBdayAsDate = m.toDate() else { return }
        guard let wBdayAsDate = w.toDate() else { return }
        guard let chosenDateAsDate = dateToConcieve.toDate() else { return }
        
        scoreMale = getDaysSinceLastAgeChange(numberOfYears: 4, bday: mBdayAsDate, chosenDate: chosenDateAsDate)
        scoreFemale = getDaysSinceLastAgeChange(numberOfYears: 3, bday: wBdayAsDate, chosenDate: chosenDateAsDate)
        
        finalResult = calculateGender(scoreM: scoreMale, scoreW: scoreFemale)
        
        print("Score male: \(scoreMale), score female: \(scoreFemale)")
    }
    
    func getDaysSinceLastAgeChange(numberOfYears: Int, bday: Date, chosenDate: Date) -> Int {
        var currentDate = bday
        var lastChangeDate: Date?
        
        while currentDate <= chosenDate {
            lastChangeDate = currentDate
            currentDate = currentDate.addYear(n: numberOfYears)
        }
        
        guard let lastChange = lastChangeDate else {
            print("No valid date found")
            return 0
        }
        
        let daysSinceChange = calendar.dateComponents([.day], from: lastChange, to: chosenDate).day ?? 0
        return daysSinceChange + 100
        
    }
    public func calculateGender(scoreM: Int, scoreW: Int) -> String {
        if scoreM < scoreW {
            return("boy")
        } else {
            return("girl")
        }
    }
    
    func isEligible (date: String) -> Bool {
        guard let bDay = date.toDate() else { return false }
        guard let eighteenYearsAgoFromToday = calendar.date(byAdding: .year, value: -18, to: Date()) else {
            return false
        }
        return bDay <= eighteenYearsAgoFromToday
    }
}



