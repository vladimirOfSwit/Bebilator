//
//  GradientButton.swift
//  Bebilator
//
//  Created by Vladimir Savic on 26.7.23..
//

import UIKit

@IBDesignable

class GradientButton: UIButton {
    // Define the colors for the gradient
    @IBInspectable var startColor: UIColor = UIColor.red {
        didSet {
            updateGradient()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.yellow {
        didSet {
            updateGradient()
        }
    }
    
    // Declare the gradient layer
    let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        // Set the gradient frame here
        gradientLayer.frame = rect
        
        // Now the colors
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        // Gradient is linear from left to right so...
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        //Add the gradient layer into the button
        layer.insertSublayer(gradientLayer, at: 0)
        
        //Finally, lets round the button corners
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
    
    func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
