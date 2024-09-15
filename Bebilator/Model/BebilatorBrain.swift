//
//  BebilatorBrain.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.11.23..
//

import Foundation


struct BebilatorBrain {
    
    var chosenDateAsString: String = ""
    var scoreMale = 0
    var scoreFemale = 0
    var finalResult = ""
    let calendar = Calendar.current
    
    public mutating func getDifferenceInAgingAndCalculateFinalResult(m: String, w: String, dateToConcieve: String) {
        
        let mBdayAsDate = formatStringToDate(date: m)
        let wBdayAsDate = formatStringToDate(date: w)
        let chosenDateAsDate = formatStringToDate(date: dateToConcieve)
        
        scoreMale = calculateAgingBetweenDates(numberOfYears: 4, bday: mBdayAsDate, chosenDate: chosenDateAsDate)
        scoreFemale = calculateAgingBetweenDates(numberOfYears: 3, bday: wBdayAsDate, chosenDate: chosenDateAsDate)
        
        print("This is the score for male \(scoreMale)")
        print("This is the score for female \(scoreFemale)")
        
        finalResult = calculateGender(scoreM: scoreMale, scoreW: scoreFemale)
        print(finalResult)
    }
    
    mutating func calculateAgingBetweenDates(numberOfYears: Int, bday: Date, chosenDate: Date) -> Int {
        
        var bdayCalculated: Date = bday
        let chosenDateFromUser = chosenDate
        var resultsOfAging: [Date] = []
        var latestChangeDate: Date?
        var daysPassedSinceChange = 0
        
        repeat {
            bdayCalculated = bdayCalculated.addYear(n: numberOfYears)
            resultsOfAging.append(bdayCalculated)
            print("Results aging \(resultsOfAging)")
            if bdayCalculated > chosenDateFromUser {
                resultsOfAging.removeLast()
                if let latestChange = resultsOfAging.last {
                    latestChangeDate = latestChange
                }
                break
            }
        } while bdayCalculated <= chosenDateFromUser
        
        let timeInterval = calendar.dateComponents([.day], from: latestChangeDate!, to: chosenDateFromUser)
        daysPassedSinceChange = (timeInterval.day ?? 0) + 100
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
}



