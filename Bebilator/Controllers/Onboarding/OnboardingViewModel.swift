//
//  OnboardingViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import UIKit

class OnboardingViewModel {
    init() {
        self.createSlides()
    }
    var slides: [OnboardingSlide] = []
    var onCurrentPageUpdated: ((String, Int) -> ())?

    private var currentPage = 0 {
        didSet {
            if currentPage < slides.count {
                if currentPage == slides.count - 1 {
                    self.onCurrentPageUpdated?("Kraj", currentPage)
                } else {
                    self.onCurrentPageUpdated?("Dalje", currentPage)
                }
            }
        }
    }
    
    func getCurrentPage() -> Int {
        self.currentPage
    }
    
    func setCurrentPage(number: Int) {
        self.currentPage = number
    }
    
    func createSlides() {
        let centerParagraphStyle = NSMutableParagraphStyle()
        centerParagraphStyle.alignment = .center
        
        let firstSlideHeadline = NSMutableAttributedString(string: "Zdravo!\n", attributes: [
            .paragraphStyle: centerParagraphStyle
        ])
     
        let firstSlideBody = NSMutableAttributedString(string: "Dobrodošli na aplikaciju zabavnog karaktera koja vam može pomoći da predvidite pol Vaše bebe. ")
        firstSlideBody.appendImage("mIconTextfield", after: "zabavnog")
        firstSlideBody.appendImage("fIconTextfield", after: "da")
        
        let firstSlideDescription = NSMutableAttributedString()
        firstSlideDescription.append(firstSlideHeadline)
        firstSlideDescription.append(firstSlideBody)
 
        
       
        slides = [OnboardingSlide(description: firstSlideDescription, image: #imageLiteral(resourceName: "itsaboy")),
                  OnboardingSlide(description: firstSlideDescription, image: #imageLiteral(resourceName: "itsagirl")),
                  OnboardingSlide(description: firstSlideDescription, image: #imageLiteral(resourceName: "boygirl"))
        ]
    }
}


