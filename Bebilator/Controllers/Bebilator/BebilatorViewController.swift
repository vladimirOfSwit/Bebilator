//
//  BebilatorViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 12.9.23..
//

import UIKit

class BebilatorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mTextfield: UITextField!
    @IBOutlet weak var wTextfield: UITextField!
    @IBOutlet weak var nTextfield: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var previousScoresBtnLbl: UIButton!
    
    var bebilatorBrain = BebilatorBrain()
    let datePickerManager = DatePickerManager()
    let viewModel = BebilatorViewModel()
    var previousScoresViewModel = PreviousScoresViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        guard let mText = mTextfield.text, mTextfield.validateGenderTextfield(isEligible: { bebilatorBrain.isEligible(date: $0)}),
              let wText = wTextfield.text, wTextfield.validateGenderTextfield(isEligible: {bebilatorBrain.isEligible(date: $0)}),
              let nText = nTextfield.text, viewModel.validateDateNotInThePast(nText, textfield: nTextfield) else {
            return
        }
      
        bebilatorBrain.getDifferenceInAgingAndCalculateFinalResult(m: mText, w: wText, dateToConcieve: nText)
        
        previousScoresViewModel.savePreviousScore(mText: mText, wText: wText, nText: nText, result: bebilatorBrain.finalResult)
        
        performSegue(withIdentifier: Constants.RESULTS_IDENTIFIER, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.RESULTS_IDENTIFIER {
            let destinationVC = segue.destination as? BebilatorResultViewController
            destinationVC?.genderResult = bebilatorBrain.finalResult
        }
        if segue.identifier == Constants.PREVIOUS_SCORES_VIEW_CONTROLLER_IDENTIFIER {
            let previousScoreVC = segue.destination as? PreviousScoresViewController
            previousScoreVC?.previousScores = previousScoresViewModel.getFormattedPreviousScores()
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        mTextfield.text = ""
        wTextfield.text = ""
        nTextfield.text = ""
    }
    
    @IBAction func previousScoresBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.PREVIOUS_SCORES_VIEW_CONTROLLER_IDENTIFIER, sender: self)
        print(previousScoresViewModel.getFormattedPreviousScores())
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
    
    private func editPlaceholderFont(textField: UITextField, placeholderText: String, fontSize: CGFloat) {
        if let currentFont = nTextfield.font {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: currentFont.withSize(12)
            ]
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }
    }
}
