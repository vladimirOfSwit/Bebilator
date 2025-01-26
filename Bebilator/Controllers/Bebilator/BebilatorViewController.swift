//
//  BebilatorViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 22.1.25..
//

import UIKit

class BebilatorViewController: UIViewController {
    
    //MARK: - UI Elements
    private let middleStackView = UIStackView()
    private let bottomStackView = UIStackView()
    private let bottomButtonsStackView = UIStackView()
    
    private let bothElephantsImageView = UIImageView()
    
    private let mTextfield = UITextField()
    private let wTextfield = UITextField()
    private let nTextfield = UITextField()
    
    private let calculateButton = GradientButton()
    private let clearButton = UIButton(type: .system)
    private let previousScoresButton = UIButton(type: .system)
    
    private let datePickerManager = DatePickerManager()
    
    var bebilatorBrain = BebilatorBrain()
    let viewModel = BebilatorViewModel()
    let bebilatorResultsViewController = BebilatorResultViewController()
    let previousScoresViewCotroller = PreviousScoresViewController()
    let previousScoresViewModel = PreviousScoresViewModel()
    private let loadingVC = LoadingViewController()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        navigationItem.title = "BEBILATOR"
        self.removeBackButtonText()
        
        bothElephantsImageView.image = UIImage(named: "bothElephants")
        bothElephantsImageView.contentMode = .scaleAspectFit
        bothElephantsImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bothElephantsImageView)
        
        middleStackView.axis = .vertical
        middleStackView.spacing = 16
        middleStackView.alignment = .fill
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(middleStackView)
        
        [mTextfield, wTextfield, nTextfield].forEach { textField in
            mTextfield.text = Constants.testingMDate
            wTextfield.text = Constants.testingWDate
            nTextfield.text = Constants.testingDateToConcieve
            
            textField.textAlignment = .center
            textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
            textField.layer.masksToBounds = true
            textField.font = UIFont(name: "SF Pro Display Bold", size: 21)
            
            mTextfield.addShadowAndRoundedCorners(color: Constants.colorMborder)
            wTextfield.addShadowAndRoundedCorners(color: Constants.colorWborder)
            nTextfield.addShadowAndRoundedCorners(color: Constants.colorNBorder)
            
            mTextfield.leftImage(UIImage(named: "mIconTextfield"), imageWidth: 20, padding: 10)
            wTextfield.leftImage(UIImage(named: "fIconTextfield"), imageWidth: 20, padding: 10)
            nTextfield.leftImage(UIImage(named: "nIconTextfield"), imageWidth: 20, padding: 10)
            
            datePickerManager.setupDatePicker(for: [mTextfield, wTextfield, nTextfield], view: self.view, target: self)
            datePickerManager.onDateSelected = { [weak self] selectedDate in
                self?.handleDateSelection(selectedDate)
            }
            
            middleStackView.addArrangedSubview(textField)
        }
        
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 30
        bottomStackView.alignment = .fill
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStackView)
        
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.addArrangedSubview(calculateButton)
        
        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.distribution = .fillProportionally
        bottomButtonsStackView.alignment = .center
        bottomButtonsStackView.spacing = 16
        bottomButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupButton(calculateButton, title: "IZRAČUNAJ", titleColor: .white, backgroundColor: .clear, isGradientButton: true)
        setupButton(clearButton, title: "Obriši", titleColor: .systemBlue, backgroundColor: .white)
        setupButton(previousScoresButton, title: "Prethodni rezultati", titleColor: .systemRed, backgroundColor: .white)
        
        [clearButton, previousScoresButton].forEach { bottomButtonsStackView.addArrangedSubview($0)}
        bottomStackView.addArrangedSubview(calculateButton)
        bottomStackView.addArrangedSubview(bottomButtonsStackView)
    }
    
    private func setupButton(_ button: UIButton, title: String, titleColor: UIColor, backgroundColor: UIColor, isGradientButton: Bool = false) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        
        if isGradientButton, let gradientButton = button as? GradientButton {
            gradientButton.startColor = .systemBlue
            gradientButton.endColor = .systemPink
            gradientButton.layer.cornerRadius = 25
            gradientButton.clipsToBounds = true
            gradientButton.titleLabel?.font = UIFont(name: "SF Pro Display Bold", size: 20)
            gradientButton.addTarget(self, action: #selector(calculateButtonPressed), for: .touchUpInside)
        } else {
            button.backgroundColor = backgroundColor
            button.layer.cornerRadius = 12
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = CGSize(width: 0, height: 3)
            button.layer.shadowRadius = 4
        }
        if button == clearButton || button == previousScoresButton {
            button.widthAnchor.constraint(equalToConstant: 120).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.titleLabel?.font = UIFont(name: "SF Pro Display Bold", size: 20)
        }
        if button == clearButton {
            button.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        }
        if button == previousScoresButton {
            previousScoresButton.addTarget(self, action: #selector(previousScoresButtonTapped), for: .touchUpInside)
        } else {
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bothElephantsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            bothElephantsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bothElephantsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bothElephantsImageView.heightAnchor.constraint(equalToConstant: 200),
            
            middleStackView.topAnchor.constraint(equalTo: bothElephantsImageView.bottomAnchor, constant: 40),
            middleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            middleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bottomStackView.topAnchor.constraint(equalTo: middleStackView.bottomAnchor, constant: 60),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
        ])
    }
    
    //MARK: - Functions
    
    private func handleDateSelection(_ date: String) {
        if mTextfield.isFirstResponder {
            mTextfield.text = date
        } else if wTextfield.isFirstResponder {
            wTextfield.text = date
        } else if nTextfield.isFirstResponder {
            nTextfield.text = date
        }
    }
    
    @objc private func calculateButtonPressed() {
        loadingVC.modalPresentationStyle = .overFullScreen
        loadingVC.onLoadingComplete = { [weak self] in
            guard let self = self else { return }
            
            self.loadingVC.dismiss(animated: true) {
                self.presentBebilatorResultViewController()
            }
        }
        present(loadingVC, animated: true)
        loadingVC.showLoadingScreen(for: 2.0)
        navigationController?.pushViewController(bebilatorResultsViewController, animated: true)
    }
    
    @objc private func clearButtonPressed() {
        [mTextfield, wTextfield, nTextfield].forEach { textField in
            textField.text = ""
            textField.editPlaceholderFont("DD/MM/YYYY", fontSize: 21)
        }
    }
    
    @objc private func previousScoresButtonTapped() {
        previousScoresViewCotroller.previousScores = previousScoresViewModel.getFormattedPreviousScores()
        navigationController?.pushViewController(previousScoresViewCotroller, animated: true)
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
    }
}

