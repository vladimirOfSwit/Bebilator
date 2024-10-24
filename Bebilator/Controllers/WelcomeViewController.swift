//
//  WelcomeViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 11.4.24..
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var bebilendarBtn: UIButton!

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
        bebilendarBtn.backgroundColor = UIColor.white
        bebilendarBtn.layer.cornerRadius = buttonHeight / 2
        bebilendarBtn.clipsToBounds = true
      
        bebilendarBtn.layer.shadowColor = UIColor.black.cgColor
        bebilendarBtn.layer.shadowOpacity = shadowOpacity
        bebilendarBtn.layer.shadowOffset = shadowOffset
        bebilendarBtn.layer.shadowRadius = shadowRadius
        bebilendarBtn.layer.masksToBounds = false
        
        bebilendarBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bebilendarBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bebilendarBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            bebilendarBtn.widthAnchor.constraint(equalToConstant: buttonWidth),
            bebilendarBtn.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    @IBAction func bebilatorButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.HOME_VIEW_CONTROLLER_IDENTIFIER, sender: self)
    }
    
    @IBAction func bebilendarButtonPressed(_ sender: UIButton) {
        print("Bebilator button pressed.")
    }
}
