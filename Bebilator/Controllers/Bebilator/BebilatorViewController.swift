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
    @IBOutlet weak var bottomViewStackView: UIStackView!
    
    let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.80
    let buttonHeight: CGFloat = 56
    let shadowOpacity: Float = 0.5
    let shadowOffset = CGSize(width: 0, height: 2)
    let shadowRadius: CGFloat = 4
    
    var bebilatorBrain = BebilatorBrain()
    let datePickerManager = DatePickerManager()
    let viewModel = BebilatorViewModel()
    var previousScoresViewModel = PreviousScoresViewModel()
    var resultViewController = BebilatorResultViewController()
    let loadingVC = LoadingViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensure that layout is finalized before applying styles
        view.layoutIfNeeded()
        applyButtonStyles()
    }

    // Apply button styles after layout is finalized
    func applyButtonStyles() {
        // Ensure layout is updated
        clearBtn.layoutIfNeeded()
        previousScoresBtnLbl.layoutIfNeeded()

        // Apply the corner radius
        clearBtn.layer.cornerRadius = clearBtn.frame.height / 2
        previousScoresBtnLbl.layer.cornerRadius = previousScoresBtnLbl.frame.height / 2
        
        // Apply shadow
        applyButtonShadow(button: clearBtn)
        applyButtonShadow(button: previousScoresBtnLbl)
    }

    // Shadow setup for the buttons
    func applyButtonShadow(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.clipsToBounds = false
    }

        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            view.layoutIfNeeded()
       }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        loadingVC.modalPresentationStyle = .overFullScreen
        loadingVC.onLoadingComplete = { [weak self] in
            guard let self = self else { return }
            
            self.loadingVC.dismiss(animated: true) {
                self.presentBebilatorResultViewController()
            }
        }
        present(loadingVC, animated: true)
        loadingVC.showLoadingScreen(for: 2.0)
    }
    
    func presentBebilatorResultViewController() {
        guard let mText = mTextfield.text, mTextfield.validateGenderTextfield(isEligible: { bebilatorBrain.isEligible(date: $0)}),
              let wText = wTextfield.text, wTextfield.validateGenderTextfield(isEligible: {bebilatorBrain.isEligible(date: $0)}),
              let nText = nTextfield.text, viewModel.validateDateNotInThePast(nText, textfield: nTextfield) else {
            return
        }
        
        bebilatorBrain.getDifferenceInAging(m: mText, w: wText, dateToConcieve: nText)
        bebilatorBrain.calculateFinalResult()
        if let gender = Gender(rawValue: bebilatorBrain.finalResult.lowercased()) {
            previousScoresViewModel.savePreviousScore(mText: mText, wText: wText, nText: nText, gender: gender)
        } else {
            print("Error: Invalid gender value '\(bebilatorBrain.finalResult)'")
        }
        
        performSegue(withIdentifier: Constants.BEBILATOR_RESULTS_VIEW_CONTROLLER, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.BEBILATOR_RESULTS_VIEW_CONTROLLER {
            if let bebilatorResultsVC = segue.destination as? BebilatorResultViewController {
                bebilatorResultsVC.genderResult = bebilatorBrain.finalResult
            }
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
    }
    
    func setupUI() {
        removeBackButtonText()
        mTextfield.text = Constants.testingMDate
        wTextfield.text = Constants.testingWDate
        nTextfield.text = Constants.testingDateToConcieve
        
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

