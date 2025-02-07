//
//  BebilatorViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 16.10.24..
//

import Foundation
import UIKit

protocol BebilatorGenderResultDelegate: AnyObject {
    func didReceiveGenderResult(_ result: String)
}

class BebilatorViewModel {
    private var bebilatorBrain = BebilatorBrain()
    private let previousScoresViewModel = PreviousScoresViewModel()
    private let bebilatorResultViewController = BebilatorResultViewController()
    
   
    var delegate: BebilatorGenderResultDelegate?
    
    
    func updateDate(_ date: String, activeField: UITextField?) {
        activeField?.text = date
    }
    
    func calculateResultFrom(mDate: String?, wDate: String?, nDate: String?) {
        guard let mDate = mDate, let wDate = wDate, let nDate = nDate    else { return }
        
        bebilatorBrain.getDifferenceInAging(m: mDate, w: wDate, dateToConcieve: nDate)
        if let gender = Gender(rawValue: bebilatorBrain.finalResult.lowercased()) {
            previousScoresViewModel.savePreviousScore(mText: mDate, wText: wDate, nText: nDate, gender: gender)
            print("Gender from BebilatorViewModel is \(gender.rawValue)")
            delegate?.didReceiveGenderResult(gender.rawValue)
        }
       
    }
    
    func resetFields(textFields: [UITextField]) {
        textFields.forEach { textField in
            textField.text = ""
            textField.editPlaceholderFont(Constants.TEXTFIELD_PLACEHOLDER, fontSize: 21)
        }
        
    }
}
