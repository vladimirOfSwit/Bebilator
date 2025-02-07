//
//  newBebilendarViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.2.25..
//

import UIKit

class newBebilendarViewController:UIViewController {
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
    private var remainingTries: Int {
        TryManager.shared.remainingTries
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //updateUIForRemainingPacifiers()
    }
    
    // Write the function that will trigger the trigger to pass the data from viewModel of BebilendarViewController to the viewModel of BebilendarResultViewController
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
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
            
            pacifierImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            pacifierImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
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
            //mTextfield.text = Constants.testingMDate
            mTextfield.editPlaceholderFont("Muški datum rodjenja.", fontSize: 20)
            //wTextfield.text = Constants.testingWDate
            wTextfield.editPlaceholderFont("Ženski datum rodjenja.", fontSize: 20)
            //futureLimitTextfield.text = Constants.testingDateToConcieve
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
            
            datePickerManager.setupDatePicker(for: [mTextfield, wTextfield, futureLimitTextfield], view: self.view, target: self)
            
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
        calculateButton.startColor = .systemBlue
        calculateButton.endColor = .systemPink
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
            
            middleStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 40),
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
        
        
    }
}
