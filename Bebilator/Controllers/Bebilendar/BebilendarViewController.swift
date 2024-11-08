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
        bindViewModel()
    }
    func bindViewModel() {
        bebilendarViewControllerModel.onValidationFailed = { [weak self ] errorMessage in
            DispatchQueue.main.async {
            switch errorMessage {
            case "mTextfield is empty.":
                self?.bebilendarViewControllerModel.showError(field: self?.mTextfield, placeholderText: "Polje ne može biti prazno.")
            case "mText is not eligible.":
                self?.mTextfield.text = ""
                self?.bebilendarViewControllerModel.showError(field: self?.mTextfield, placeholderText: "Min. 18. godina")
            case "wTextfield is empty.":
                self?.bebilendarViewControllerModel.showError(field: self?.wTextfield, placeholderText: "Polje ne može biti prazno")
            case "wText is not eligible.":
                self?.mTextfield.text = ""
                self?.bebilendarViewControllerModel.showError(field: self?.wTextfield, placeholderText: "Min 18. godina")
            case "Future limit is not valid.":
                self?.bebilendarViewControllerModel.showError(field: self?.futureLimitTextfield, placeholderText: "Polje mora biti broj.")
            default:
                print("Error in binding.")
                }
            }
        }
        bebilendarViewControllerModel.onSwitchingPeriodUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.bebilendarResultControllerModel.switchingPeriods = self.bebilendarViewControllerModel.switchingPeriods
                self.performSegue(withIdentifier: Constants.BEBILENDAR_RESULTS_VIEW_CONTROLLER_IDENTIFIER, sender: self)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.BEBILENDAR_RESULTS_VIEW_CONTROLLER_IDENTIFIER {
            let destinationVC = segue.destination as? BebilendarResultViewController
            destinationVC?.viewModel.switchingPeriods = bebilendarViewControllerModel.switchingPeriods
            print("BebilendarViewController to BebilendarResultViewModel: \(destinationVC?.viewModel.switchingPeriods)")
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func calculateSwitchingPeriodsButtonPressed(_ sender: UIButton) {
    let success = bebilendarViewControllerModel.validateAndCalculateSwitchingPeriods(mBirthdateString: mTextfield.text, wBirthdateString: wTextfield.text, futureLimitString: futureLimitTextfield.text)
        if success {
            print("Switching periods populated from calculateSwitchingPeriodsButtonPressed with: \(bebilendarViewControllerModel.switchingPeriods)")
        } else {
            print("Failed to populate the switching periods array.")
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
}

extension BebilendarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == futureLimitTextfield {
            futureLimitTextfield.resignFirstResponder()
        }
        return true
    }
}
