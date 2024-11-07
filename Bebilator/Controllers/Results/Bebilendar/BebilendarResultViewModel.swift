//
//  BebilendarResultViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 5.11.24..
//

import iCarousel
import UIKit

class BebilendarResultViewModel {
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    
    let resultsCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .coverFlow
        return view
    }()
    func updateCarousel() {
        resultsCarousel.reloadData()
    }
    
    func formattedText(for index: Int) -> String {
        guard index < switchingPeriods.count else {
            return "Invalid index"
        }
        let period = switchingPeriods[index]
        return "GODINA: \(period.year) \nMESEC: \(period.month) \nDAN: \(period.day)"
    }
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
    func styledLabel(for index: Int, frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "SF Pro Medium", size: 14)
        label.text = formattedText(for: index)
        return label
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
}

