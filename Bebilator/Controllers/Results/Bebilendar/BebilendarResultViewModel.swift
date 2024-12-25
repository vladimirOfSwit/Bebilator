//
//  BebilendarResultViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 5.11.24..
//


import UIKit

class BebilendarResultViewModel {
    var switchingPeriods: [(year: Int, month: String, day: Int, gender: String)] = []
    
//    func formattedText(for period: (year: Int, month: String, day: Int, gender: String)) -> NSAttributedString {
//        let yearAttributedText = attributedText(with: "yearIcon", text: "\(period.year)")
//        let monthAttributedText = attributedText(with: "monthIcon", text: "\(period.month)")
//        let dayAttributedText = attributedText(with: "dayIcon", text: "\(period.day)")
//        
//        let finalAttributedText = NSMutableAttributedString()
//        finalAttributedText.append(yearAttributedText)
//        finalAttributedText.append(monthAttributedText)
//        finalAttributedText.append(dayAttributedText)
//        
//        return finalAttributedText
//    }
    
    func genderIcon (for gender: String) -> UIImage? {
        switch gender.lowercased() {
        case "boy":
            return UIImage(named: "blueBabyIcon")
        case "girl":
            return UIImage(named: "pinkBabyIcon")
        default:
            return nil
        }
    }
    
    func styledContainerView(frame: CGRect) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }
    
//    func attributedText(with imageName: String, text: String) -> NSAttributedString {
//        let attachment = NSTextAttachment()
//        attachment.image = UIImage(named: imageName)
//        attachment.bounds = CGRect(x: 0, y: -3, width: 20, height: 20)
//        
//        let attributedString = NSMutableAttributedString(attachment: attachment)
//        attributedString.append(NSAttributedString(string: " \(text)\n"))
//        
//        return attributedString
//    }
}

