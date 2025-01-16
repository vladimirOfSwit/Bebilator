//
//  BebilendarResultViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 5.11.24..
//


import UIKit

class BebilendarResultViewModel {
    var switchingPeriods: [SwitchingPeriod] = []
    
    func genderIcon (for gender: Gender) -> UIImage? {
        switch gender {
        case .boy:
            return UIImage(named: "blueBabyIcon")
        case .girl:
            return UIImage(named: "pinkBabyIcon")
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
}

