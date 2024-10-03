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
        
        setupUI()

    }
    
    func setupUI() {
        
          // Modify the button
          bebilendarBtn.frame = CGRect(x: 0, y: 0, width: 342, height: 56)
          bebilendarBtn.backgroundColor = UIColor.white
          
          // Round the corners
          bebilendarBtn.layer.cornerRadius = 28
          bebilendarBtn.clipsToBounds = true
        
          bebilendarBtn.layer.shadowColor = UIColor.black.cgColor
          bebilendarBtn.layer.shadowOpacity = 0.5
          bebilendarBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
          bebilendarBtn.layer.shadowRadius = 4
          bebilendarBtn.layer.masksToBounds = false
    }
    
    
    @IBAction func bebilatorButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.HOME_VIEW_CONTROLLER_IDENTIFIER, sender: self)
    }
    
    @IBAction func bebilendarButtonPressed(_ sender: UIButton) {
        print("Bebilator button pressed.")
    }
    
    
}
