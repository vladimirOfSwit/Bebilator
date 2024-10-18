//
//  BebilendarViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 8.10.24..
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
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func calculateSwitchingPeriodsButtonPressed(_ sender: UIButton) {
        guard let mText = mTextfield.text, mTextfield.validateGenderTextfield(isEligible: { bebilatorBrain.isEligible(date: $0) }),
              let wText = wTextfield.text, wTextfield.validateGenderTextfield(isEligible: { bebilatorBrain.isEligible(date: $0) }) else {
             return
         }
        guard futureLimitTextfield.text?.isEmpty == false,
               futureLimitTextfield.text != Constants.TEXTFIELD_PLACEHOLDER,
               let futureLimit = Int(futureLimitTextfield.text ?? "No value") else {
             futureLimitTextfield.placeholder = "Unesite broj"
             futureLimitTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
             return
         }
        
        guard let mBdayAsDate = mText.toDate(),
              let wBdayAsDate = wText.toDate() else { return }
        
        let result = viewModel.calculateSwitchingPeriods(mBirthdate: mBdayAsDate, wBirthdate: wBdayAsDate, futureLimit: futureLimit)
        for (year, month, day, gender) in result {
            print("Year: \(year), Month: \(month), Day: \(day), Gender: \(gender)")
        }
        
        performSegue(withIdentifier: Constants.SWITCH_PERIODS_VIEW_CONTROLLER_RESULTS_IDENTIFIER, sender: self)
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
