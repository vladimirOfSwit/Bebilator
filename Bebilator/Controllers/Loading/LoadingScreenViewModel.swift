//
//  LoadingScreenViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 3.12.24..
//

import UIKit

class LoadingScreenViewModel {
    func createGradientLayer(for frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = frame
        return gradientLayer
    }
}
