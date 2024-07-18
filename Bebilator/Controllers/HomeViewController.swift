//
//  HomeViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 12.9.23..
//

import UIKit



class HomeViewController: UIViewController, UITextFieldDelegate {
    
    
    var bebilatorBrain = BebilatorBrain()
    
    @IBOutlet weak var mTextfield: UITextField!
    
    @IBOutlet weak var wTextfield: UITextField!
    
    @IBOutlet weak var nTextfield: UITextField!
    
    @IBOutlet weak var clearBtn: UIButton!
    
    @IBOutlet weak var previousScoresBtnLbl: UIButton!
    
    let dateFormatter = DateFormatter()
   
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupDatePicker()
        
        UserDefaults.standard.hasOnboarded = false
        
        
    }
    
    
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        
        
        guard mTextfield.text?.isEmpty == false, mTextfield.text != K.TEXTFIELD_PLACEHOLDER else {
            mTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 6, revert: true)
            return
       }
        
        guard wTextfield.text?.isEmpty == false, wTextfield.text != K.TEXTFIELD_PLACEHOLDER else {
            wTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
            return
        }
        
        guard nTextfield.text?.isEmpty == false, nTextfield.text != K.TEXTFIELD_PLACEHOLDER else {
            nTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
            return
        }
        
        guard let mText = mTextfield.text,
              let wText = wTextfield.text,
              let nText = nTextfield.text else {
            return
        }
        
        bebilatorBrain.getDifferenceInAgingAndCalculateFinalResult(m: mText, w: wText, dateToConcieve: nText)
        
        performSegue(withIdentifier: K.RESULTS_IDENTIFIER, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.RESULTS_IDENTIFIER {
            let destinationVC = segue.destination as? ResultsViewController
            destinationVC?.genderResult = bebilatorBrain.finalResult
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        mTextfield.text = ""
        wTextfield.text = ""
        nTextfield.text = ""
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
        }
        if textField == nTextfield {
            datePicker.date = Date()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
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
