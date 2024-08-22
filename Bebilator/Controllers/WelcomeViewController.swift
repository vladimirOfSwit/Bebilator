//
//  WelcomeViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 11.4.24..
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var bebilendarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bebilendarBtn.layer.masksToBounds = false
        bebilendarBtn.layer.shadowRadius = 15.0
        bebilendarBtn.layer.shadowColor = UIColor.red.cgColor
        bebilendarBtn.layer.shadowOffset = CGSize(width: -5.0, height: -5.0)
        bebilendarBtn.layer.shadowOpacity = 1.0
        bebilendarBtn.layer.cornerRadius = 7
        bebilendarBtn.layer.borderColor = UIColor.black.cgColor
        bebilendarBtn.layer.borderWidth = 3.0
        bebilendarBtn.clipsToBounds = true
    }
    
    @IBAction func bebilatorButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.HOME_VIEW_CONTROLLER_IDENTIFIER, sender: self)
    }
    
    
}
