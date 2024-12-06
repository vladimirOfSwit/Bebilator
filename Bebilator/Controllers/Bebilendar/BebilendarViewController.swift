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
        if let parsedError = bebilendarViewControllerModel.validateInputValuesFrom(mBirthdateString: mTextfield.text, wBirthdateString: wTextfield.text, futureLimitString: futureLimitTextfield.text) {
            let textFieldWithError: UITextField?
            switch parsedError.field {
            case .mTextfield:
                textFieldWithError = mTextfield
            case .wTextfield:
                textFieldWithError = wTextfield
            case .futureLimitTextfield:
                textFieldWithError = futureLimitTextfield
            }
            showError(field: textFieldWithError, placeholderText: parsedError.text)
        } else {
            bebilendarViewControllerModel.getTheFinalResults()
            performSegue(withIdentifier: Constants.BEBILENDAR_RESULTS_VIEW_CONTROLLER_IDENTIFIER, sender: self)
        }
    }
    
    func setupUI() {
        mTextfield.addShadowAndRoundedCorners(color: Constants.colorMborder)
        wTextfield.addShadowAndRoundedCorners(color: Constants.colorWborder)
        futureLimitTextfield.addShadowAndRoundedCorners(color: Constants.colorNBorder)
        
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
