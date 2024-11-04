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
    
    var viewModel = BebilendarViewModel()
    var bebilatorBrain = BebilatorBrain()
    let datePickerManager = DatePickerManager()
    let resultViewController = BebilendarResultViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    func bindViewModel() {
        viewModel.onValidationFailed = { [weak self ] errorMessage in
            DispatchQueue.main.async {
            switch errorMessage {
            case "mTextfield is empty.":
                self?.viewModel.showError(field: self?.mTextfield, placeholderText: "Polje ne može biti prazno.")
            case "mText is not eligible.":
                self?.mTextfield.text = ""
                self?.viewModel.showError(field: self?.mTextfield, placeholderText: "Min. 18. godina")
            case "wTextfield is empty.":
                self?.viewModel.showError(field: self?.wTextfield, placeholderText: "Polje ne može biti prazno")
            case "wText is not eligible.":
                self?.mTextfield.text = ""
                self?.viewModel.showError(field: self?.wTextfield, placeholderText: "Min 18. godina")
            case "Future limit is not valid.":
                self?.viewModel.showError(field: self?.futureLimitTextfield, placeholderText: "Polje mora biti broj.")
            default:
                print("Error in binding.")
                }
            }
        }
        viewModel.onSwitchingPeriodUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: Constants.BEBILENDAR_RESULTS_VIEW_CONTROLLER_IDENTIFIER, sender: self)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.BEBILENDAR_RESULTS_VIEW_CONTROLLER_IDENTIFIER {
            let destinationVC = segue.destination as? BebilendarResultViewController
            destinationVC?.switchingPeriods = viewModel.switchingPeriods
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func calculateSwitchingPeriodsButtonPressed(_ sender: UIButton) {
    _ = viewModel.validateAndCalculateSwitchingPeriods(mBirthdateString: mTextfield.text, wBirthdateString: wTextfield.text, futureLimitString: futureLimitTextfield.text)
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
}

extension BebilendarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == futureLimitTextfield {
            futureLimitTextfield.resignFirstResponder()
        }
        return true
    }
}
