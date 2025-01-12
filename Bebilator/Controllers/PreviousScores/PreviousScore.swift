//
//  PreviousScore.swift
//  Bebilator
//
//  Created by Vladimir Savic on 24.10.24..
//

import Foundation

enum Gender: String, Codable {
    case boy
    case girl
}

struct PreviousScore: Codable {
    let mText: String
    let wText: String
    let nText: String
    let gender: Gender
    let date: Date
}
