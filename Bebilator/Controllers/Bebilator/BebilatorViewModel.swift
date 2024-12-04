//
//  BebilatorViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 16.10.24..
//

import Foundation
import UIKit

class BebilatorViewModel {
    func validateDateNotInThePast(_ dateAsString: String, textfield: UITextField) -> Bool {
        guard !dateAsString.isEmpty, dateAsString != Constants.TEXTFIELD_PLACEHOLDER else {
            textfield.placeholder = "Polje ne može biti prazno."
            textfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
            return false
        }
        guard let selectedDate = dateAsString.toDate(), compareDates(selectedDate, textfield) else {
            return false
        }
        return true
    }
    
    private func compareDates(_ date: Date, _ textField: UITextField) -> Bool {
        let calendar = Calendar.current
        let todaysStartDate  = calendar.startOfDay(for: Date())
        let selectedStartDate = calendar.startOfDay(for: date)
        
        guard selectedStartDate >= todaysStartDate  else {
            textField.editPlaceholderFont("Datum mora biti današnji ili u budućnosti.", fontSize: 12)
            textField.text = ""
            textField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
        return false
        }
        return true
    }
}
