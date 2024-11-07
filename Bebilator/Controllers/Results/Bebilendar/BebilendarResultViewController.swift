//
//  BebilendarResultViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit
import iCarousel

class BebilendarResultViewController: UIViewController, iCarouselDataSource {
    var viewModel = BebilendarResultViewModel()
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(viewModel.resultsCarousel)
        viewModel.resultsCarousel.dataSource = self
        viewModel.resultsCarousel.frame = CGRect(x: 0, 
                                                 y: 200,
                                                 width: view.frame.size.width,
                                                 height: 400)
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        let count = viewModel.switchingPeriods.count
        print("Number of items in carousel is \(count)")
        return count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 1.3, height: 300))
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        
        let stackView = UIStackView(frame: containerView.bounds.insetBy(dx: 10, dy: 10))
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        containerView.addSubview(stackView)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = viewModel.genderIcon(for: switchingPeriods[index].gender)
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stackView.addArrangedSubview(imageView)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "SF Pro Medium", size: 16)
        label.text = viewModel.formattedText(for: index)
        label.textColor = .black
        stackView.addArrangedSubview(label)
    
        return containerView
    }
    func updateData() {
        viewModel.switchingPeriods = switchingPeriods
        print("The data from viewWillAppear: \(switchingPeriods)")
        viewModel.updateCarousel()
    }
}


