//
//  CarouselView.swift
//  Bebilator
//
//  Created by Vladimir Savic on 7.11.24..
//

import UIKit
import iCarousel

class CarouselView: UIView, iCarouselDataSource {
    private let carousel: iCarousel
    private var items: [CarouselItem]
    
    init(frame: CGRect, items: [CarouselItem]) {
        self.carousel = iCarousel()
        self.items = items
        super.init(frame: frame)
        
        setupCarousel()
        addSubview(carousel)
        carousel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        carousel.frame = bounds
        carousel.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupCarousel() {
        carousel.type = .coverFlow
        carousel.dataSource = self
        
        carousel.isPagingEnabled = true
        carousel.bounceDistance = 0.5
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        items.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 0.8, height: 300))
        containerView.backgroundColor = .white
        containerView.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        containerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = items[index].image
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stackView.addArrangedSubview(imageView)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "SF Pro Medium", size: 14)
        label.attributedText = items[index].attributedText
        label.textColor = .black
        stackView.addArrangedSubview(label)
        
        return containerView
    }
}
