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
    
    
    let datePicker = UIDatePicker()
    
    let dateFormatter = DateFormatter()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupDatePicker()
        
        
        
        
    }
    
    
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
      
        
        
        
        guard let mBdaySafe = mTextfield.text else {return}
        
        guard let wBdaySafe = wTextfield.text else { return }
        
        guard let nDateSafe = nTextfield.text else { return }
        
        
        
        bebilatorBrain.getDifferenceInAgingAndCalculateFinalResult(m: mBdaySafe, w: wBdaySafe, dateToConcieve: nDateSafe)
        
        
        
        performSegue(withIdentifier: Constants.RESULTS_IDENTIFIER, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.RESULTS_IDENTIFIER {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.genderResult = bebilatorBrain.finalResult
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        mTextfield.text = ""
        wTextfield.text = ""
        nTextfield.text = ""
    }
    
    
    
    
    
    func setupUI() {
        
        
        let colorMborder = UIColor(hex: "#6B92E5CC")
        let colorWborder = UIColor(hex: "#F88AB0CC")
        let colorNBorder = UIColor(hex: "#7B81BECC")
        
        
        mTextfield.layer.borderColor = colorMborder?.cgColor
        mTextfield.layer.borderWidth = 2.0
        mTextfield.layer.cornerRadius = 16
        mTextfield.clipsToBounds = true
        mTextfield.textAlignment = .center
        
        wTextfield.layer.borderColor = colorWborder?.cgColor
        wTextfield.layer.borderWidth = 2.0
        wTextfield.layer.cornerRadius = 16
        wTextfield.clipsToBounds = true
        
        nTextfield.layer.borderColor = colorNBorder?.cgColor
        nTextfield.layer.borderWidth = 2.0
        nTextfield.layer.cornerRadius = 16
        nTextfield.clipsToBounds = true
        
        mTextfield.leftImage(UIImage(named: "mIconTextfield"), imageWidth: 5, padding: 10)
        wTextfield.leftImage(UIImage(named: "fIconTextfield"), imageWidth: 5, padding: 10)
        nTextfield.leftImage(UIImage(named: "nIconTextfield"), imageWidth: 5, padding: 10)
        
        
    }
    
    
    func setupDatePicker() {
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
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
