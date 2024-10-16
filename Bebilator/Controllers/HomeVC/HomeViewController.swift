//
//  HomeViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 12.9.23..
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mTextfield: UITextField!
    @IBOutlet weak var wTextfield: UITextField!
    @IBOutlet weak var nTextfield: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var previousScoresBtnLbl: UIButton!
    
    var bebilatorBrain = BebilatorBrain()
    let datePickerManager = DatePickerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        guard bebilatorBrain.validateTextField(mTextfield, placeHolderEmpty: "Polje ne može biti prazno.", placeholderNotEligible: "Min 18. godina") else {
            return
        }
        
        guard bebilatorBrain.validateTextField(wTextfield, placeHolderEmpty: "Polje ne može biti prazno.", placeholderNotEligible: "Min 18. godina") else {
            return
        }
        
        guard nTextfield.text?.isEmpty == false, nTextfield.text != Constants.TEXTFIELD_PLACEHOLDER else {
            nTextfield.placeholder = "Polje ne može biti prazno"
            nTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
            return
        }
        guard let mText = mTextfield.text, 
              let wText = wTextfield.text,
              let nText = nTextfield.text else {
        return
        }
        bebilatorBrain.getDifferenceInAgingAndCalculateFinalResult(m: mText, w: wText, dateToConcieve: nText)
        
        performSegue(withIdentifier: Constants.RESULTS_IDENTIFIER, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.RESULTS_IDENTIFIER {
            let destinationVC = segue.destination as? ResultsViewController
            destinationVC?.genderResult = bebilatorBrain.finalResult
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        mTextfield.text = ""
        wTextfield.text = ""
        nTextfield.text = ""
    }
    
    @IBAction func previousScoresBtnPressed(_ sender: UIButton) {
    }
    
    func setupUI() {
        mTextfield.addShadowAndRoundedCorners(color: Constants.colorMborder)
        wTextfield.addShadowAndRoundedCorners(color: Constants.colorWborder)
        nTextfield.addShadowAndRoundedCorners(color: Constants.colorNBorder)
        
        mTextfield.leftImage(UIImage(named: "mIconTextfield"), imageWidth: 5, padding: 10)
        wTextfield.leftImage(UIImage(named: "fIconTextfield"), imageWidth: 5, padding: 10)
        nTextfield.leftImage(UIImage(named: "nIconTextfield"), imageWidth: 5, padding: 10)
        
        datePickerManager.setupDatePicker(for: [mTextfield, wTextfield, nTextfield], view: self.view, target: self)
        datePickerManager.onDateSelected = { [weak self] selectedDate in
            self?.handleDateSelection(selectedDate)
        }
    }
    
    private func handleDateSelection(_ date: String) {
        if mTextfield.isFirstResponder {
            mTextfield.text = date
        } else if wTextfield.isFirstResponder {
            wTextfield.text = date
        } else if nTextfield.isFirstResponder {
            nTextfield.text = date
        }
    }
}
