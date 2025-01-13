//
//  BebilendarResultViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit

class BebilendarResultViewController: UIViewController {
    var switchingPeriods: [SwitchingPeriod] = []
    var viewModel = BebilendarResultViewModel()
    private var carouselView: CarouselView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCarouselView()
    }
    
    private func setupCarouselView() {
        let items = viewModel.switchingPeriods.map { period in
            let imageName = period.gender.lowercased() == "boy" ? "blueBabyIcon" : "pinkBabyIcon"
            let image = UIImage(named: imageName)
            image?.accessibilityIdentifier = imageName
            
            return CarouselItem(year: period.year, day: period.day, month: period.month, gender: period.gender)
            
        }
        let carouselView = CarouselView(frame: .zero, items: items)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(carouselView)
        NSLayoutConstraint.activate([
            carouselView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            carouselView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            carouselView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            carouselView.heightAnchor.constraint(equalToConstant: 300)
        ])
        self.carouselView = carouselView
    }
}


