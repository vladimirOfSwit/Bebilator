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
    
    func setupOnboardingSlides() {
        slides = [
            createSlideUsing(
                headline: "Zdravo!",
                body: "Dobrodošli!🌟 Zabavna pogađalica pola bebe je pred Vama! Ova aplikacija koristi staru metodu iz vremena kada su bake znale sve i internet nije postojao. Da li će biti dečak ili devojčica? Hajde da zajedno saznamo – ko zna, možda i pogodimo! 😉",
                slideImageName: "itsaboy"
            ),
            createSlideUsing(
                headline: "Okej, igra počinje! 🎯",
                body: "Unesite tri datuma – jedan muški(), jedan ženski() i datum kada planirate bebu() ili kada je otprilike začeta ukoliko ste već trudni – i Bebilator će Vam odmah šapnuti: plava ili roze odeća? 🍼🎀 ",
                inlineImages: [("mIconTextfield", "ški("),
                               ("fIconTextfield", "ski("),
                               ("nIconTextfield", "bu(")],
                slideImageName: "itsagirl"
            ),
            createSlideUsing(
                headline: "Šta je Bebilendar?",
                body: "Planirajte sa osmehom! Bebilendar Vam pomaže da otkrijete koji meseci „nagoveštavaju“ dečaka, a koji devojčicu – sve na osnovu Vašeg rođendana. Zabavan kalendar za roditelje koji vole da maštaju i uživaju u svakom koraku do dolaska bebe! U zavisnosti od rezultata kartice u Bebilendaru će biti plave ili roze Srećno!",
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


