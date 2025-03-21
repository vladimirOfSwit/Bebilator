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
        let customFont = UIFont(name: "Avenir Next-Bold", size: 12) ?? UIFont.systemFont(ofSize: 16)
        
        let firstSlideDescription = NSMutableAttributedString()
        let firstSlideHeadline = NSMutableAttributedString(string: "Zdravo!\n", attributes: [
            .paragraphStyle: centerParagraphStyle,
                .font: customFont
        ])
        let firstSlideBody = NSMutableAttributedString(string: "Dobrodošli!🌟 Zabavna pogađalica pola bebe je pred Vama! Ova aplikacija koristi staru metodu iz vremena kada su bake znale sve i internet nije postojao. Da li će biti dečak ili devojčica? Hajde da zajedno saznamo – ko zna, možda i pogodimo! 😉")
        firstSlideDescription.append(firstSlideHeadline)
        firstSlideDescription.append(firstSlideBody)
        
        let secondSlideDescription = NSMutableAttributedString()
        let secondSlideHeadline = NSMutableAttributedString(string: "Okej, igra počinje! 🎯\n", attributes: [
            .paragraphStyle: centerParagraphStyle,
            .font: customFont
        ])
        let secondSlideBody = NSMutableAttributedString(string: "Unesite tri datuma – jedan muški(), jedan ženski() i datum kada planirate bebu() ili kada je otprilike začeta ukoliko ste već trudni – i Bebilator će Vam odmah šapnuti: plava ili roze odeća? 🍼🎀 ")
        secondSlideBody.appendImage("mIconTextfield", after: "ški(")
        secondSlideBody.appendImage("fIconTextfield", after: "ski(")
        secondSlideBody.appendImage("nIconTextfield", after: "bu(")
        secondSlideDescription.append(secondSlideHeadline)
        secondSlideDescription.append(secondSlideBody)
        
        let thirdSlideDescription = NSMutableAttributedString()
        let thirdSlideHeadline = NSMutableAttributedString(string: "Šta je Bebilendar?\n", attributes: [
            .paragraphStyle: centerParagraphStyle,
            .font: customFont
        ])
        let thirdSlideBody = NSMutableAttributedString(string: "Planirajte sa osmehom! Bebilendar Vam pomaže da otkrijete koji meseci „nagoveštavaju“ dečaka, a koji devojčicu – sve na osnovu Vašeg rođendana. Zabavan kalendar za roditelje koji vole da maštaju i uživaju u svakom koraku do dolaska bebe! U zavisnosti od rezultata kartice u Bebilendaru će biti plave ili roze Srećno!")
        thirdSlideBody.appendImage("blueBabyIcon", after: "plave")
        thirdSlideBody.appendImage("pinkBabyIcon", after: "roze")
        thirdSlideDescription.append(thirdSlideHeadline)
        thirdSlideDescription.append(thirdSlideBody)
        
        slides = [OnboardingSlide(description: firstSlideDescription, image: #imageLiteral(resourceName: "itsaboy")),
                  OnboardingSlide(description: secondSlideDescription, image: #imageLiteral(resourceName: "itsagirl")),
                  OnboardingSlide(description: thirdSlideDescription, image: #imageLiteral(resourceName: "boygirl"))
        ]
    }
}


