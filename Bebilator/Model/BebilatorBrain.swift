//
//  BebilatorBrain.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.11.23..
//

import Foundation
import UIKit

struct BebilatorBrain {
    
   
    var finalResult = ""
    let calendar = Calendar.current
    var scoreMale = 0
    var scoreFemale = 0
    
    public mutating func getDifferenceInAging(m: String, w: String, dateToConcieve: String) {
        guard let mBdayAsDate = m.toDate() else { return }
        guard let wBdayAsDate = w.toDate() else { return }
        guard let chosenDateAsDate = dateToConcieve.toDate() else { return }
        
        scoreMale = getDaysSinceLastAgeChange(numberOfYears: 4, bday: mBdayAsDate, chosenDate: chosenDateAsDate)
        print(scoreMale)
        scoreFemale = getDaysSinceLastAgeChange(numberOfYears: 3, bday: wBdayAsDate, chosenDate: chosenDateAsDate)
        print(scoreFemale)
        
        calculateFinalResult()
        print("Final FIRST and REAL result from bebilatorBrain is: \(finalResult)")
        
        
    }
    
    mutating func calculateFinalResult() {
        if scoreMale < scoreFemale {
            finalResult = "boy"
        } else {
            finalResult = "girl"
        }
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
    
    func isEligible (date: String) -> Bool {
        guard let bDay = date.toDate() else { return false }
        guard let eighteenYearsAgoFromToday = calendar.date(byAdding: .year, value: -18, to: Date()) else {
            return false
        }
        return bDay <= eighteenYearsAgoFromToday
    }
}



