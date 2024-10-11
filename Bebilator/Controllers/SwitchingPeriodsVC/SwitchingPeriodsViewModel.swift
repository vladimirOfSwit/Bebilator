//
//  SwitchingPeriodsViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 8.10.24..
//

import Foundation

class SwitchingPeriodsViewModel {
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    var onSwitchingPeriodUpdated: (() -> ())?
    let calendar = Calendar.current
    var bebilatorBrain = BebilatorBrain()
    
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
