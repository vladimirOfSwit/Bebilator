//
//  SwitchingPeriod.swift
//  Bebilator
//
//  Created by Vladimir Savic on 13.1.25..
//

import Foundation

struct SwitchingPeriod: Codable {
    let year: Int
    let month: Int
    let day: Int
    let gender: Gender
    var monthName: String {
        if let monthEntry = Constants.monthsInSerbian.first(where: {$0.0 == month}) {
            return monthEntry.1
        } else {
           return "Nepoznat mesec"
        }
    }
}


