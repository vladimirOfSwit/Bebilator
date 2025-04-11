//
//  BebilendarViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.2.25..
//

import UIKit

class BebilendarViewController:UIViewController {
    private let mTextfield = UITextField()
    private let wTextfield = UITextField()
    private let futureLimitTextfield = UITextField()
    private let pregnantGirlImageView = UIImageView()
    private let calculateButton = GradientButton()
    private var remainingPacifiers: [UIImageView] =  []
    
    
    private let topStackView = UIStackView()
    private let middleStackView = UIStackView()
    private let bottomStackView = UIStackView()
    private let datePickerManager = DatePickerManager()
    
    private let viewModel = BebilendarViewModel()
    private let loadingVC = LoadingViewController()
    
    private lazy var textfields = [mTextfield, wTextfield, futureLimitTextfield]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUIForRemainingTries()
        updatePacifierImages()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "BEBILENDAR"
        self.removeBackButtonText()
        
        topStackView.axis = .horizontal
        topStackView.alignment = .center
        topStackView.distribution = .fillEqually
        topStackView.spacing = 3
        
        for _ in 0..<3 {
            let pacifierImageView = UIImageView()
            pacifierImageView.image = UIImage(named: "pacifier")
            pacifierImageView.contentMode = .scaleAspectFit
            pacifierImageView.translatesAutoresizingMaskIntoConstraints = false
            
            pacifierImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            pacifierImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            
            topStackView.addArrangedSubview(pacifierImageView)
            remainingPacifiers.append(pacifierImageView)
        }
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStackView)
        
        middleStackView.axis = .vertical
        middleStackView.spacing = 16
        middleStackView.alignment = .fill
        middleStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(middleStackView)
        
        [mTextfield, wTextfield, futureLimitTextfield].forEach { textField in
            mTextfield.text = Constants.testingMDate
            mTextfield.editPlaceholderFont(NSLocalizedString("Male date of birth.", comment: "textfield placeholder for male birthdate"), fontSize: 20)
            wTextfield.text = Constants.testingWDate
            wTextfield.editPlaceholderFont(NSLocalizedString("Female date of birth.", comment: "textfield placeholder for female birthdate"), fontSize: 20)
            futureLimitTextfield.text = Constants.testingFutureLimit
            futureLimitTextfield.editPlaceholderFont(NSLocalizedString("Insert the number of years in the future", comment: "textfield placeholder value for number of days in the future"), fontSize: 20)
            
            textField.delegate = self
            textField.textAlignment = .center
            textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
            textField.layer.masksToBounds = true
            textField.font = UIFont(name: "SF Pro Display Bold", size: 21)
            
            mTextfield.addShadowAndRoundedCorners(color: Constants.colorMborder)
            wTextfield.addShadowAndRoundedCorners(color: Constants.colorWborder)
            futureLimitTextfield.addShadowAndRoundedCorners(color: Constants.colorNBorder)
            
            mTextfield.leftImage(UIImage(named: "mIconTextfield"), imageWidth: 20, padding: 10)
            wTextfield.leftImage(UIImage(named: "fIconTextfield"), imageWidth: 20, padding: 10)
            futureLimitTextfield.leftImage(UIImage(named: ""), imageWidth: 20, padding: 10)
            
            datePickerManager.setupDatePicker(for: [mTextfield, wTextfield], view: self.view, target: self)
            
            middleStackView.addArrangedSubview(textField)
        }
        
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 0
        bottomStackView.alignment = .fill
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStackView)
        
        pregnantGirlImageView.image = UIImage(named: "pregnantLady")
        pregnantGirlImageView.translatesAutoresizingMaskIntoConstraints = false
        pregnantGirlImageView.contentMode = .scaleAspectFit
        bottomStackView.addArrangedSubview(pregnantGirlImageView)
        
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        calculateButton.startColor = UIColor(hex: "#6B92E5")
        calculateButton.endColor = UIColor(hex: "#F88AB0")
        calculateButton.layer.cornerRadius = 25
        calculateButton.clipsToBounds = true
        calculateButton.titleLabel?.font = UIFont(name: "SF Pro Display Bold", size: 20)
        calculateButton.addTarget(self, action: #selector(calculateButtonPressed), for: .touchUpInside)
        calculateButton.setTitle(NSLocalizedString("CALCULATE", comment: "calculate Button value"), for: .normal)
        
        bottomStackView.addArrangedSubview(calculateButton)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            middleStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20),
            middleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            middleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            calculateButton.heightAnchor.constraint(equalToConstant: 60),
            bottomStackView.topAnchor.constraint(equalTo: middleStackView.bottomAnchor, constant: 30),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func calculateButtonPressed() {
        if textfields.validateTextfieldsAreNotEmpty(textfields) == true && futureLimitTextfield.validateValueIsInt() == true {
            TryManager.shared.recordTry()
            if TryManager.shared.isOutOfTries {
                disableTextfieldsAndCalculateButton()
                showAlert(title: NSLocalizedString("You are out of pacifiers.", comment: "title of the alert informing the users they need to buy more pacifiers"), message: NSLocalizedString("If you want to continue guessing, add more pacifiers.", comment: "message informing the user they need to buy more pacifiers"))
            } else {
                handleRemainingTries()
                presentTheLoadingScreen()
            }
        }
    }
    
    private func handleRemainingTries() {
        print("Remaining tries: \(TryManager.shared.remainingTries)")
        if TryManager.shared.isOutOfTries {
            disableTextfieldsAndCalculateButton()
        }
        else {
            updatePacifierImages()
        }
    }
    
    private func navigateToPurchaseScreen() {
        let storeVC = StoreViewController()
        navigationController?.pushViewController(storeVC, animated: true)
    }
    
    private func updateUIForRemainingTries() {
        print("Preostali broj pokušaja: \(String(TryManager.shared.remainingTries))")
        print("Broj na counteru: \(TryManager.shared.counterOfTaps)")
        if TryManager.shared.isOutOfTries {
            disableTextfieldsAndCalculateButton()
            showAlert(title: NSLocalizedString("You are out of pacifiers.", comment: "title of the alert informing the users they need to buy more pacifiers"), message: NSLocalizedString("If you want to continue guessing, add more pacifiers.", comment: "message informing the user they need to buy more pacifiers"))
        } else {
            resetInputFields()
        }
    }
    
    private func resetInputFields() {
        calculateButton.isUserInteractionEnabled = true
        calculateButton.alpha = 1.0
        textfields.forEach {
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .white
        }
    }
    
    private func disableTextfieldsAndCalculateButton() {
        calculateButton.isUserInteractionEnabled = false
        calculateButton.alpha = 0.3
        textfields.forEach {
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = UIColor.lightGray
        }
       
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let lastResultAction = UIAlertAction(title: NSLocalizedString("Last result", comment: "action taking the user to the BebilendarResultViewController"), style: .default) { _ in
            self.presentTheResultsScreen()
        }
        
        alert.addAction(lastResultAction)
        
        let purchaseAction = UIAlertAction(title: NSLocalizedString("Add more pacifiers", comment: "action taking the user to the purchase page to buy pacifiers"), style: .default) { _ in
            self.navigateToPurchaseScreen()
        }
        
        alert.addAction(purchaseAction)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        alert.addAction(okAction)
        
       if let topViewController = UIApplication.shared.topMostViewController() {
            topViewController.present(alert, animated: true)
           return
        }
    }
    
    private func setupBindings() {
        datePickerManager.onDateSelected = { [weak self] selectedDate in
            guard let self = self else { return }
            let textfields = [mTextfield, wTextfield, futureLimitTextfield]
            guard let _ = textfields.validateAndReturnActiveTextFieldWithValidValue(selectedDate) else { return }
            
        }
        loadingVC.onLoadingComplete = { [weak self] in
            guard let self = self else { return }
            self.loadingVC.dismiss(animated: true) {
                if TryManager.shared.isOutOfTries {
                    self.showAlert(
                        title: NSLocalizedString("You are out of pacifiers.", comment: "title of the alert informing the users they need to buy more pacifiers"), message: NSLocalizedString("If you want to continue guessing, add more pacifiers.", comment: "message informing the user they need to buy more pacifiers")
                    )
                    return
                }
                
                guard let mBirthdateAsString = self.mTextfield.text,
                      let wBirthdateAsString = self.wTextfield.text,
                      let futureLimitTextfieldAsString = self.futureLimitTextfield.text else { return }
                
                guard let mBirthdateAsDate = mBirthdateAsString.toDate(),
                      let wBirthdateAsDate = wBirthdateAsString.toDate(),
                      let futureLimitAsInt = Int(futureLimitTextfieldAsString) else { return }
                
                self.viewModel.mBirthdate = mBirthdateAsDate
                self.viewModel.wBirthdate = wBirthdateAsDate
                self.viewModel.futureLimit = futureLimitAsInt
                
                self.viewModel.getTheFinalResult()
                
                self.presentTheResultsScreen()
                
            }
        }
    }
    
    private func presentTheResultsScreen() {
        let resultVC = BebilendarResultViewController()
        resultVC.switchingPeriods = self.viewModel.switchingPeriods
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    private func presentTheLoadingScreen() {
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: true)
        loadingVC.showLoadingScreen(for: 1.0)
    }
    
    private func updatePacifierImages() {
        for (index, pacifier) in remainingPacifiers.enumerated() {
            UIView.animate(withDuration: 0.3) {
                pacifier.alpha = index < TryManager.shared.remainingTries ? 1.0 : 0.3
            }
        }
    }
}

extension BebilendarViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == futureLimitTextfield {
            futureLimitTextfield.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
