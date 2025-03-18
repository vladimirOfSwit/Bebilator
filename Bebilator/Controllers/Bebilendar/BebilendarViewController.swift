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
    private var remainingTries: Int {
        TryManager.shared.remainingTries
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUIForRemainingTries()
        //TryManager.shared.purchasedTries = 0
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
        topStackView.distribution = .equalSpacing
        topStackView.spacing = 20
        
        for _ in 0..<3 {
            let pacifierImageView = UIImageView()
            pacifierImageView.image = UIImage(named: "pacifier")
            pacifierImageView.contentMode = .scaleAspectFit
            pacifierImageView.translatesAutoresizingMaskIntoConstraints = false
            
            pacifierImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            pacifierImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
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
            mTextfield.editPlaceholderFont("Muški datum rodjenja.", fontSize: 20)
            wTextfield.text = Constants.testingWDate
            wTextfield.editPlaceholderFont("Ženski datum rodjenja.", fontSize: 20)
            futureLimitTextfield.text = Constants.testingFutureLimit
            futureLimitTextfield.editPlaceholderFont("Broj godina u budućnosti", fontSize: 20)
            
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
        calculateButton.startColor = UIColor(hex: "#6B92E5") ?? .systemBlue
        calculateButton.endColor = UIColor(hex: "#F88AB0") ?? .systemPink
        calculateButton.layer.cornerRadius = 25
        calculateButton.clipsToBounds = true
        calculateButton.titleLabel?.font = UIFont(name: "SF Pro Display Bold", size: 20)
        calculateButton.addTarget(self, action: #selector(calculateButtonPressed), for: .touchUpInside)
        calculateButton.setTitle("IZRAČUNAJ", for: .normal)
        
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
        if calculateButton.title(for: .normal) == "Poslednji rezultat" {
            navigationController?.pushViewController(BebilendarResultViewController(), animated: true)
            return
        }
        
        if textfields.validateTextfieldsAreNotEmpty(textfields) == true && futureLimitTextfield.validateValueIsInt() == true {
            handleRemainingTries()
            presentTheLoadingScreen()
            
        }
    }
    
    private func handleRemainingTries() {
        print("Remaining tries: \(remainingTries)")
        
        if remainingTries > 0 {
            TryManager.shared.counter += 1
            viewModel.getTheFinalResult()
        }
        else {
            calculateButton.setTitle("POSLEDNJI REZULTAT", for: .normal)
            disableInputFields()
            showAlert(
                title: "Obaveštenje",
                message: "Iskoristili ste maksimalni broj pokušaja. Dokupite tokene.",
                actionTitle: "Dokupite tokene",
                actionHandler: {self.navigateToPurchaseScreen()}
            )
        }
        
    }
    
    
    
    
    
    private func navigateToPurchaseScreen() {
        TryManager.shared.purchasedTries += 3
        updateUIForRemainingTries()
    }
    
    private func updateUIForRemainingTries() {
        print("Preostali broj pokušaja: \(String(TryManager.shared.remainingTries))")
        
        if remainingTries > 0 {
            resetInputFields()
            calculateButton.setTitle("IZRAČUNAJ", for: .normal)
        } else {
            calculateButton.setTitle("POSLEDNJI REZULTAT", for: .normal)
            disableInputFields()
        }
    }
    
    private func resetInputFields() {
        textfields.forEach {
            $0.isUserInteractionEnabled = true
            $0.backgroundColor = .white
        }
    }
    
    private func disableInputFields() {
        textfields.forEach {
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = UIColor.lightGray
        }
    }
    
    private func showAlert(title: String, message: String, actionTitle: String, actionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            actionHandler?()
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        if let topViewController = UIApplication.shared.topMostViewController() {
            topViewController.present(alert, animated: true)
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
                
                let resultVC = BebilendarResultViewController()
                resultVC.switchingPeriods = self.viewModel.switchingPeriods
                self.navigationController?.pushViewController(resultVC, animated: true)
                
            }
        }
        
    }
    
    private func presentTheLoadingScreen() {
        loadingVC.modalPresentationStyle = .fullScreen
        present(loadingVC, animated: true)
        loadingVC.showLoadingScreen(for: 1.0)
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
