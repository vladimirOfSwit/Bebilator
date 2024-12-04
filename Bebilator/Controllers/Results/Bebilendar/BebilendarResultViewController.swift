//
//  BebilendarResultViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit

class BebilendarResultViewController: UIViewController {
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    var viewModel = BebilendarResultViewModel()
    private var carouselView: CarouselView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCarouselView()
    }
    
    private func setupCarouselView() {
        let items = viewModel.switchingPeriods.map { period in
            CarouselItem(
                image: period.gender.lowercased() == "boy" ? UIImage(named: "blueBabyIcon") : UIImage(named: "pinkBabyIcon"),
                attributedText: viewModel.formattedText(for: period))
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


