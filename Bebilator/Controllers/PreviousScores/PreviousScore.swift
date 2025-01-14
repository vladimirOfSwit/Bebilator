//
//  PreviousScore.swift
//  Bebilator
//
//  Created by Vladimir Savic on 24.10.24..
//

import Foundation

struct PreviousScore: Codable {
    let mTextfieldValue: String
    let wTextfieldValue: String
    let nTextfieldValue: String
    let gender: Gender
    let date: Date
}
