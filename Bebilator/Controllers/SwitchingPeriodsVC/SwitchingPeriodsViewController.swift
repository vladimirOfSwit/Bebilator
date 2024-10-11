//
//  SwitchingPeriodsViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 8.10.24..
//
import Foundation
import UIKit


class SwitchingPeriodsViewController: UIViewController {
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var mTextfield: UITextField!
    @IBOutlet weak var wTextfield: UITextField!
    @IBOutlet weak var futureLimitTextfield: UITextField!
    
    var viewModel = SwitchingPeriodsViewModel()
    var bebilatorBrain = BebilatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func calculateSwitchingPeriodsButtonPressed(_ sender: GradientButton) {
        guard bebilatorBrain.validateTextField(mTextfield, placeHolderEmpty: "Polje ne može biti prazno.", placeholderNotEligible: "Min 18. godina") else {
            return
        }
        
        guard bebilatorBrain.validateTextField(wTextfield, placeHolderEmpty: "Polje ne može biti prazno.", placeholderNotEligible: "Min 18. godina") else {
            return
        }
        
        guard futureLimitTextfield.text?.isEmpty == false, futureLimitTextfield.text != Constants.TEXTFIELD_PLACEHOLDER, let futureLimit = Int(futureLimitTextfield.text ?? "No value") else {
            futureLimitTextfield.placeholder = "Unesite broj"
            futureLimitTextfield.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 4, revert: true)
            return
        }
        
        
        
        //let result = bebilatorBrain.calculateSwitchingPeriods(mBirthdate: <#T##Date#>, wBirthdate: <#T##Date#>, futureLimit: <#T##Int#>)
    }
    
    func setupUI() {
        mTextfield.addShadowAndRoundedCorners(color: Constants.colorMborder)
        wTextfield.addShadowAndRoundedCorners(color: Constants.colorWborder)
        futureLimitTextfield.addShadowAndRoundedCorners(color: Constants.colorNBorder)
        
        mTextfield.leftImage(UIImage(named: "mIconTextfield"), imageWidth: 5, padding: 10)
        wTextfield.leftImage(UIImage(named: "fIconTextfield"), imageWidth: 5, padding: 10)
    }
}
