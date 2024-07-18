//
//  OnboardingViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 16.7.24..
//

import UIKit


class OnboardingViewModel {

    var slides: [OnboardingSlide] = []

    var onCurrentPageUpdated: ((String, Int) -> ())?

    private var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                self.onCurrentPageUpdated?("Kraj", currentPage)
                UserDefaults.standard.hasOnboarded = true
            } else {
                self.onCurrentPageUpdated?("Dalje", currentPage)
            }
        }
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage
    }
    
    func setCurrentPage(number: Int) {
        self.currentPage = number
    }
    
    func fetchSlides() {
   
        
       slides = [OnboardingSlide(description: "Test prvi ekran", image: #imageLiteral(resourceName: "itsaboy")),
                 OnboardingSlide(description: "Test drugi ekran", image: #imageLiteral(resourceName: "itsagirl")),
                 OnboardingSlide(description: "Test treci ekran", image: #imageLiteral(resourceName: "boygirl"))
       ]
    }
}

struct OnboardingSlide {
    let description: String
    let image: UIImage
}

