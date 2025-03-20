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
      
        // Insert first image after
        let firstSlideDescription = NSMutableAttributedString(string: "Zdravo! Dobrodošli na aplikaciju zabavnog karaktera koja vam može pomoći da predvidite pol Vaše bebe. ")
        
        firstSlideDescription.appendImage(UIImage(named: "mIconTextfield")!, after: "aplikaciju")
        
       
        slides = [OnboardingSlide(description: firstSlideDescription, image: #imageLiteral(resourceName: "itsaboy")),
                  OnboardingSlide(description: firstSlideDescription, image: #imageLiteral(resourceName: "itsagirl")),
                  OnboardingSlide(description: firstSlideDescription, image: #imageLiteral(resourceName: "boygirl"))
        ]
    }
}


