//
//  SwitchingPeriod.swift
//  Bebilator
//
//  Created by Vladimir Savic on 13.1.25..
//

import Foundation

struct SwitchingPeriod {
    let year: Int
    let month: Int
    let day: Int
    let gender: Gender
    var monthName: String {
        Constants.monthsInSerbian[month - 1] ?? "Nepoznat mesec"
    }
}


