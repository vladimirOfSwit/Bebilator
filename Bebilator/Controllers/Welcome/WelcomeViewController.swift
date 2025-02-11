//
//  WelcomeViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 11.4.24..
//

import UIKit

class WelcomeViewController: UIViewController {
    private let welcomeImageView = UIImageView()
    private let bebilatorButton = GradientButton()
    private let bebilendarButton = UIButton(type: .system)
    private let bottomStackView = UIStackView()
    
    let buttonWidth: CGFloat = UIScreen.main.bounds.width * 0.80
    let buttonHeight: CGFloat = 56
    let shadowOpacity: Float = 0.5
    let shadowOffset = CGSize(width: 0, height: 2)
    let shadowRadius: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        welcomeImageView.image = UIImage(named: "boyGirlWelcome")
        welcomeImageView.translatesAutoresizingMaskIntoConstraints = false
        welcomeImageView.contentMode = .scaleAspectFit
        
        view.addSubview(welcomeImageView)
        
        bottomStackView.axis = .vertical
        bottomStackView.alignment = .fill
        bottomStackView.spacing = 15
        bottomStackView.distribution = .fillEqually
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomStackView)
        
        bebilatorButton.translatesAutoresizingMaskIntoConstraints = false
        bebilatorButton.startColor = UIColor(hex: "#6B92E5") ?? .systemRed
        bebilatorButton.endColor = UIColor(hex: "#F88AB0") ?? .systemGray
        bebilatorButton.layer.cornerRadius = 25
        bebilatorButton.clipsToBounds = true
        bebilatorButton.addTarget(self, action: #selector(bebilatorButtonPressed), for: .touchUpInside)
        bebilatorButton.titleLabel?.font = UIFont(name: "SF Pro Display Bold", size: 20)
        bebilatorButton.setTitle("Bebilator", for: .normal)
        bottomStackView.addArrangedSubview(bebilatorButton)
        
        removeBackButtonText()
        bebilendarButton.backgroundColor = UIColor.white
        bebilendarButton.layer.cornerRadius = buttonHeight / 2
        bebilendarButton.clipsToBounds = true
        bebilendarButton.addTarget(self, action: #selector(bebilendarButtonPressed), for: .touchUpInside)
        bebilendarButton.titleLabel?.font = UIFont(name: "SF Pro Display Bold", size: 20)
        bebilendarButton.setTitle("Bebilendar", for: .normal)
        bebilendarButton.setTitleColor(.systemBlue, for: .normal)
        
        bebilendarButton.layer.shadowColor = UIColor.black.cgColor
        bebilendarButton.layer.shadowOpacity = shadowOpacity
        bebilendarButton.layer.shadowOffset = shadowOffset
        bebilendarButton.layer.shadowRadius = shadowRadius
        bebilendarButton.layer.masksToBounds = false
        
        bottomStackView.addArrangedSubview(bebilendarButton)
        
        bebilendarButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            welcomeImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            welcomeImageView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10),
            welcomeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bebilatorButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            bebilendarButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            bottomStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bottomStackView.topAnchor.constraint(equalTo: welcomeImageView.bottomAnchor, constant: 40),
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            bottomStackView.widthAnchor.constraint(equalToConstant: buttonWidth),
           
        ])
    }
    
    @objc private func bebilatorButtonPressed() {
        let bebilatorVC = BebilatorViewController()
        bebilatorVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(bebilatorVC, animated: true)
    }
    
    @objc func bebilendarButtonPressed(_ sender: UIButton) {
        let bebilendarVC = BebilendarViewController()
        bebilendarVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(bebilendarVC, animated: true)
    }
}
