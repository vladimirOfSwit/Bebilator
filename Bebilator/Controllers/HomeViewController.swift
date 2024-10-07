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
    let dateFormatter = DateFormatter()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        guard validateTextField(mTextfield, placeHolderEmpty: "Polje ne može biti prazno.", placeholderNotEligible: "Min 18. godina") else {
            return
        }
        
        guard validateTextField(wTextfield, placeHolderEmpty: "Polje ne može biti prazno.", placeholderNotEligible: "Min 18. godina") else {
            return
        }
        
        guard nTextfield.text?.isEmpty == false, nTextfield.text != K.TEXTFIELD_PLACEHOLDER else {
            nTextfield.placeholder = "Polje ne može biti prazno"
            nTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
            return
        }
        
        bebilatorBrain.getDifferenceInAgingAndCalculateFinalResult(m: mTextfield.text!, w: wTextfield.text!, dateToConcieve: nTextfield.text!)
        
        performSegue(withIdentifier: K.RESULTS_IDENTIFIER, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.RESULTS_IDENTIFIER {
            let destinationVC = segue.destination as? ResultsViewController
            destinationVC?.genderResult = bebilatorBrain.finalResult
        }
    }
    
    func validateTextField(_ textField: UITextField, placeHolderEmpty: String, placeholderNotEligible: String) -> Bool {
        guard let text = textField.text, !text.isEmpty, text != K.TEXTFIELD_PLACEHOLDER else {
            textField.text = ""
            textField.placeholder = placeHolderEmpty
            textField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 6, revert: true)
            return false
        }
        
        if !bebilatorBrain.isEligible(date: text) {
            textField.text = ""
            textField.placeholder = placeholderNotEligible
            textField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 6, revert: true)
            return false
        }
        return true
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        mTextfield.text = ""
        wTextfield.text = ""
        nTextfield.text = ""
    }
    
    @IBAction func previousScoresBtnPressed(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        if let mBirthdate = dateFormatter.date(from: "08.06.1987"),
           let wBirthdate = dateFormatter.date(from: "19.01.1988") {
            
            let result = bebilatorBrain.calculateSwitchingPeriods(mBirthdate: mBirthdate, wBirthdate: wBirthdate)
            for (year, month, day, gender) in result {
            print("Year: \(year), Month: \(month), Day: \(day), Gender: \(gender)")
            }
        }
    }
    
    func setupUI() {
        mTextfield.addShadowAndRoundedCorners()
        wTextfield.addShadowAndRoundedCorners()
        nTextfield.addShadowAndRoundedCorners()
        
        mTextfield.leftImage(UIImage(named: "mIconTextfield"), imageWidth: 5, padding: 10)
        wTextfield.leftImage(UIImage(named: "fIconTextfield"), imageWidth: 5, padding: 10)
        nTextfield.leftImage(UIImage(named: "nIconTextfield"), imageWidth: 5, padding: 10)
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        datePicker.setValue(true, forKeyPath: "highlightsToday")
        let transparent = UIColor(red: 50.00 , green: 255.0, blue: 100.00, alpha: 0.0)
        datePicker.subviews.first?.subviews.last?.backgroundColor = transparent
   
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(tapOnDoneButt))
        toolBar.setItems([doneBtn], animated: true)
        
        mTextfield.inputAccessoryView = toolBar
        wTextfield.inputAccessoryView = toolBar
        nTextfield.inputAccessoryView = toolBar
        
        mTextfield.inputView = datePicker
        wTextfield.inputView = datePicker
        nTextfield.inputView = datePicker
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mTextfield {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
        }
        if textField == wTextfield {
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.maximumDate = Date()
        }
        if textField == nTextfield {
            datePicker.date = Date()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.minimumDate = Date()
        }
    }
    
    @objc func tapOnDoneButt() {
        if mTextfield.isFirstResponder {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            mTextfield.text = bebilatorBrain.formatDateToString(date: datePicker.date)
        }
        if wTextfield.isFirstResponder {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            wTextfield.text = bebilatorBrain.formatDateToString(date: datePicker.date)
        }
        if nTextfield.isFirstResponder {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            nTextfield.text = bebilatorBrain.formatDateToString(date: datePicker.date)
        }
        
        self.view.endEditing(true)
    }
}
