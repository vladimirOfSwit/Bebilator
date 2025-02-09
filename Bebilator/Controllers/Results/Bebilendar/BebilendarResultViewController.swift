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
        print("Switching periods from BebilendarResultViewController: \(switchingPeriods)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    private func setupCarouselView() {
        let items = switchingPeriods.map { period in
            let monthName = period.monthName
            return CarouselItem(year: period.year,
                                day: period.day,
                                month: monthName,
                                gender: period.gender)
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


