//
//  Constants.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.11.23..
//

import UIKit

struct Constants {
    static let BEBILATOR_RESULTS_VIEW_CONTROLLER = "goToBebilatorResults"
    static let HOME_VIEW_CONTROLLER_IDENTIFIER = "goToBebilator"
    static let BEBILENDAR_VIEW_CONTROLLER_IDENTIFIER = "goToBebilendar"
    static let BEBILENDAR_RESULTS_VIEW_CONTROLLER_IDENTIFIER = "goToBebilendarResults"
    static let PREVIOUS_SCORES_VIEW_CONTROLLER_IDENTIFIER = "goToPreviousScoresViewController"
    static let TEXTFIELD_PLACEHOLDER = "DD/MM/GGGG"
    static let APP_NAME = "BEBILATOR"
    static let colorMborder = UIColor(hex: "#6B92E5CC")
    static let colorWborder = UIColor(hex: "#F88AB0CC")
    static let colorNBorder = UIColor(hex: "#7B81BECC")
    static let monthsInSerbian = [
        (1, "Januar"),
        (2, "Februar"),
        (3, "Mart"),
        (4, "April"),
        (5, "Maj"),
        (6, "Jun"),
        (7, "Jul"),
        (8, "Avgust"),
        (9, "Septembar"),
        (10, "Oktobar"),
        (11, "Novembar"),
        (12, "Decembar")
        ]
    static let testingMDate = "28.01.2000"
    static let testingWDate = "19.07.2002"
    static let testingDateToConcieve = "22.07.2025"
    static let testingFutureLimit = "10"
}
