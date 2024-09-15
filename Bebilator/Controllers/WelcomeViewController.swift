//
//  WelcomeViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 11.4.24..
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var bebilendarBtn: UIButton!

    let buttonWidth: CGFloat = 342
    let buttonHeight: CGFloat = 56
    let cornerRadius: CGFloat = 28
    let shadowOpacity: Float = 0.5
    let shadowOffset = CGSize(width: 0, height: 2)
    let shadowRadius: CGFloat = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        bebilendarBtn.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        bebilendarBtn.backgroundColor = UIColor.white
        
        bebilendarBtn.layer.cornerRadius = cornerRadius
        bebilendarBtn.clipsToBounds = true
      
        bebilendarBtn.layer.shadowColor = UIColor.black.cgColor
        bebilendarBtn.layer.shadowOpacity = shadowOpacity
        bebilendarBtn.layer.shadowOffset = shadowOffset
        bebilendarBtn.layer.shadowRadius = shadowRadius
        bebilendarBtn.layer.masksToBounds = false
    }
    
    @IBAction func bebilatorButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.HOME_VIEW_CONTROLLER_IDENTIFIER, sender: self)
    }
    
    @IBAction func bebilendarButtonPressed(_ sender: UIButton) {
        print("Bebilator button pressed.")
    }
}
