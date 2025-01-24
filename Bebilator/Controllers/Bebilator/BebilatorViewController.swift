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
    @IBOutlet weak var previousScoreBtn: GradientButton!
    @IBOutlet weak var bottomViewStackView: UIStackView!
    
    var bebilatorBrain = BebilatorBrain()
    let datePickerManager = DatePickerManager()
    let viewModel = BebilatorViewModel()
    var previousScoresViewModel = PreviousScoresViewModel()
    var resultViewController = BebilatorResultViewController()
    let loadingVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundTheButtons()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        roundTheButtons()
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("Stack view frame: \(bottomViewStackView.frame)")
            print("Clear button frame: \(clearBtn.frame)")
            print("Previous score button frame: \(previousScoreBtn.frame)")
        // Force the stack view to layout its subviews
            bottomViewStackView.layoutIfNeeded()
            view.layoutIfNeeded()
            
            // Check frames are valid
            guard clearBtn.frame.width > 0, previousScoreBtn.frame.width > 0 else { return }
            
            // Style the buttons
            roundTheButtons()
    }
    
    
    
    
    func roundTheButtons() {
       print("clearBtn frame: \(clearBtn.frame), previousScoreBtn frame: \(previousScoreBtn.frame)")
        
        clearBtn.layer.cornerRadius = 20
        previousScoreBtn.layer.cornerRadius = 20
        
        
        clearBtn.layer.shadowColor = UIColor.black.cgColor
        clearBtn.layer.shadowOpacity = 0.2
        clearBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        clearBtn.layer.shadowRadius = 4
        
        previousScoreBtn.layer.shadowColor = UIColor.black.cgColor
        previousScoreBtn.layer.shadowOpacity = 0.2
        previousScoreBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        previousScoreBtn.layer.shadowRadius = 4
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
    
    private func setupConstraints() {
        // Remove autoresizing mask constraints
        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        previousScoreBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // Set explicit constraints for width and height
        NSLayoutConstraint.activate([
            clearBtn.widthAnchor.constraint(equalToConstant: 120),
            clearBtn.heightAnchor.constraint(equalToConstant: 40),
            
            previousScoreBtn.widthAnchor.constraint(equalToConstant: 120),
            previousScoreBtn.heightAnchor.constraint(equalToConstant: 40),
            
            // Optionally constrain stack view to its parent view
            bottomViewStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomViewStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomViewStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
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

