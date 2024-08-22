//
//  OnboardingCollectionViewCell.swift
//  Bebilator
//
//  Created by Vladimir Savic on 27.7.23..
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideDescriptionLbl: UILabel!
    
    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
        slideDescriptionLbl.text = slide.description
    }
    
}
