//
//  BebilendarViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit


class BebilendarViewController: UIViewController {
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var mTextfield: UITextField!
    @IBOutlet weak var wTextfield: UITextField!
    @IBOutlet weak var futureLimitTextfield: UITextField!
    
    var bebilendarViewControllerModel = BebilendarViewModel()
    var bebilendarResultControllerModel = BebilendarResultViewModel()
    let datePickerManager = DatePickerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.BEBILENDAR_RESULTS_VIEW_CONTROLLER_IDENTIFIER {
            let destinationVC = segue.destination as? BebilendarResultViewController
            destinationVC?.viewModel.switchingPeriods = bebilendarViewControllerModel.switchingPeriods
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func calculateSwitchingPeriodsButtonPressed(_ sender: UIButton) {
        if let validationError = bebilendarViewControllerModel.validateInputValuesFrom(mBirthdateString: mTextfield.text, wBirthdateString: wTextfield.text, futureLimitString: futureLimitTextfield.text) {
            let errorField = determineTextField(for: validationError.field)
            showError(field: errorField, placeholderText: validationError.errorText)
        } else {
            let remainingTries = TryManager.shared.maxTries + TryManager.shared.purchasedTries - TryManager.shared.counter
            infoLbl.text = "Preostali broj pogadjanja je \(String(remainingTries))"
            
            if remainingTries > 0 {
                TryManager.shared.counter += 1
                bebilendarViewControllerModel.getTheFinalResult()
                performSegue(withIdentifier: Constants.BEBILENDAR_RESULTS_VIEW_CONTROLLER_IDENTIFIER, sender: self)
            } else {
                disableInputFields()
                showAlert(
                    title: "Nemate više pokušaja",
                    message: "Iskoristili ste maksimalni broj pokušaja"
                )
            }
        }
    }
    
    func disableInputFields() {
        [mTextfield, wTextfield, futureLimitTextfield].forEach {
            $0?.isUserInteractionEnabled = false
            $0?.backgroundColor = UIColor.lightGray
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    func determineTextField(for field: FieldIdentifier) -> UITextField? {
        switch field {
        case .mTextfield:
            return mTextfield
        case .wTextfield:
            return wTextfield
        case .futureLimitTextfield:
            return futureLimitTextfield
        }
    }
    
    func setupUI() {
        mTextfield.addShadowAndRoundedCorners(color: Constants.colorMborder)
        wTextfield.addShadowAndRoundedCorners(color: Constants.colorWborder)
        futureLimitTextfield.addShadowAndRoundedCorners(color: Constants.colorNBorder)
        
        mTextfield.text = "24.12.1997"
        wTextfield.text = "26.04.1995"
        futureLimitTextfield.text = "15"
        
        futureLimitTextfield.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        mTextfield.leftImage(UIImage(named: "mIconTextfield"), imageWidth: 5, padding: 10)
        wTextfield.leftImage(UIImage(named: "fIconTextfield"), imageWidth: 5, padding: 10)
        
        datePickerManager.setupDatePicker(for: [mTextfield, wTextfield], view: self.view, target: self)
        datePickerManager.onDateSelected = {[weak self] selectedDate in
            self?.handleDateSelection(selectedDate)
        }
    }
    
    private func handleDateSelection(_ date: String) {
        if mTextfield.isFirstResponder {
            mTextfield.text = date
        } else if wTextfield.isFirstResponder {
            wTextfield.text = date
        }
    }
    
    func showError(field: UITextField?, placeholderText: String) {
        field?.text = ""
        field?.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 4, revert: true)
        field?.placeholder = placeholderText
    }
}

extension BebilendarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == futureLimitTextfield {
            futureLimitTextfield.resignFirstResponder()
        }
        return true
    }
}
