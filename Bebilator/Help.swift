//
//  Help.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.10.24..
//

import Foundation

struct Help {
    
    var bebilatorBrain = BebilatorBrain()
    
    // Function to calculate years when gender switches between "boy" and "girl"
    func calculateSwitchingYears(mBirthdate: Date, wBirthdate: Date) -> [(year: Int, gender: String)] {
        var switchingYears: [(year: Int, gender: String)] = [] // Array to store the year and gender
        let currentYear  = Calendar.current.component(.year, from: Date()) // Get current year
        let futureLimit = 50 // Limit the future years to 50
        
        var lastGender = "" // Keep track of the last gender
        
        // Loop through the range from current year to future limit
        for year in currentYear...(currentYear + futureLimit) {
            // Create a Date from the year (Int)
            var dateComponents = DateComponents()
            dateComponents.year = year
            let chosenDate = Calendar.current.date(from: dateComponents) ?? Date()
            
            // Calculate scores for male and female
            let maleScore = bebilatorBrain.getDaysSinceLastAgeChange(numberOfYears: 4, bday: mBirthdate, chosenDate: chosenDate)
            let femaleScore = bebilatorBrain.getDaysSinceLastAgeChange(numberOfYears: 3, bday: wBirthdate, chosenDate: chosenDate)
            
            // Determine the current gender based on the score
            let currentGender = maleScore < femaleScore ? "boy" : "girl"
            
            // Check if the current gender is different from the last year
            if currentGender != lastGender {
                switchingYears.append((year, currentGender)) // Add the year and gender to the array
                lastGender = currentGender  // Update the lastGender to the current one
            }
        }
        
        // Return the array of tuples with years and associated gender
        return switchingYears
    }
    
}
