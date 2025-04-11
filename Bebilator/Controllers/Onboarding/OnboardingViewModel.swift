//
//  OnboardingViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import UIKit

class OnboardingViewModel {
    init() {
        self.setupOnboardingSlides()
    }
    var slides: [OnboardingSlide] = []
    var onCurrentPageUpdated: ((String, Int) -> ())?

    private var currentPage = 0 {
        didSet {
            if currentPage < slides.count {
                if currentPage == slides.count - 1 {
                    self.onCurrentPageUpdated?(NSLocalizedString("Finish", comment: "done button on OnboardingSlides"), currentPage)
                } else {
                    self.onCurrentPageUpdated?(NSLocalizedString("Next", comment: "next button on OnboardingSlides"), currentPage)
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
    
    func setupOnboardingSlides() {
        slides = [
            createSlideUsing(
                headline: NSLocalizedString("Hello", comment: "headline of the first OnboardingSlide"),
                body: NSLocalizedString("Welcome!🌟 A fun baby gender guessing game is in front of you! This app uses an old method from when grandmas knew everything and the internet didn't exist. Will it be a boy or a girl? Let's find out together - who knows, maybe we'll guess! 😉", comment: "body of the first OnboardingSlide"),
                slideImageName: "itsaboy"
            ),
            createSlideUsing(
                headline: NSLocalizedString("Let’s start the game! 🎯", comment: "headline of the second OnboardingSlide"),
                body: NSLocalizedString("Enter three dates – one male, one female, and the date when you’re planning to have a baby (or the approximate conception date if you're already pregnant) – and Bebilator will immediately whisper to you: blue or pink clothes? 🍼🎀 ", comment: "body of the second OnboardingSlide"),
                inlineImages: [("mIconTextfield", "ški("),
                               ("fIconTextfield", "ski("),
                               ("nIconTextfield", "bu(")],
                slideImageName: "itsagirl"
            ),
            createSlideUsing(
                headline: NSLocalizedString("What is Bebilendar?", comment: "headline of the third OnboardingSlide"),
                body: NSLocalizedString("Plan with a smile! Bebilendar helps you discover which months 'hint' at a boy and which at a girl – all based on your birthday. A fun calendar for parents who love to dream and enjoy every step on the journey to their baby’s arrival! Depending on the result, the cards in Bebilendar will be blue or pink. Good luck!", comment: "body of the third OnboardingSlided"),
                inlineImages: [("blueBabyIcon", "plave"),
                               ("pinkBabyIcon", "roze")],
                slideImageName: "boygirl"
            )
        ]
    }
    
    func createSlideUsing(headline: String,
                     body: String,
                     inlineImages: [(imageName: String, after: String)] = [],
                     slideImageName: String? = nil) -> OnboardingSlide {
        
        let centerParagraphStyle = NSMutableParagraphStyle()
        centerParagraphStyle.alignment = .center
        centerParagraphStyle.lineSpacing = 4
        centerParagraphStyle.paragraphSpacing = 10
        
        let customFont = UIFont(name: "SFUIText-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)
        let attributedText = NSMutableAttributedString()
        let headlineAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: centerParagraphStyle,
            .font: customFont,
        ]
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: customFont
            ]
        
        attributedText.append(NSAttributedString(string: "\(headline)\n", attributes: headlineAttributes))
        let bodyText = NSMutableAttributedString(string: body, attributes: bodyAttributes)
        
        attributedText.append(bodyText)
        let slideImage = slideImageName != nil ? UIImage(named: slideImageName!) : nil
        
        return OnboardingSlide(attributedText: attributedText, image: slideImage)
    }
}


