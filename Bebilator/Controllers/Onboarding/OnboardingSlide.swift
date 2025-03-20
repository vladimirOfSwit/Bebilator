//
//  OnboardingSlide.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.12.24..
//

import UIKit

struct OnboardingSlide {
    var description: NSAttributedString
    var image: UIImage
    
    init(description: NSMutableAttributedString, image: UIImage) {
        self.description = description
        self.image = image
    }
}
