//
//  CarouselView.swift
//  Bebilator
//
//  Created by Vladimir Savic on 7.11.24..
//

import UIKit
import iCarousel

class CarouselView: UIView, iCarouselDataSource, iCarouselDelegate {
    private let carousel: iCarousel
    private var items: [CarouselItem]
    private var toolTip: Tooltip?
    
    init(frame: CGRect, items: [CarouselItem]) {
        self.carousel = iCarousel()
        self.items = items
        super.init(frame: frame)
        
        setupCarousel()
        addSubview(carousel)
        carousel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        carousel.frame = bounds
        carousel.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_ :)))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCarousel() {
        carousel.type = .coverFlow
        carousel.dataSource = self
        carousel.delegate = self
        
        carousel.isPagingEnabled = true
        carousel.bounceDistance = 0.5
    }
    
    @objc func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        toolTip?.removeFromSuperview()
        toolTip = nil
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        setupCarouselView(indexOfTheCarousel: index)
    }
    
   private func setupCarouselView(indexOfTheCarousel: Int) -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 237.3, height: 281))
        let period = items[indexOfTheCarousel]
        
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = period.gender.rawValue == "boy" ? UIColor.systemBlue.cgColor : UIColor.systemPink.cgColor
        
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 5
        
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        containerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: 0.8)
        ])
        
       
        let genderImageView = UIImageView()
        genderImageView.contentMode = .scaleAspectFit
        genderImageView.image = period.gender.rawValue == "boy" ? UIImage(named: "blueBabyIcon"): UIImage(named: "pinkBabyIcon")
        genderImageView.translatesAutoresizingMaskIntoConstraints = false
        genderImageView.widthAnchor.constraint(equalToConstant: 123).isActive = true
        genderImageView.heightAnchor.constraint(equalToConstant: 94).isActive = true
        
        stackView.addArrangedSubview(genderImageView)
        
      
        containerView.backgroundColor = period.gender.rawValue == "boy" ? UIColor.systemBlue.withAlphaComponent(0.1) : UIColor.systemPink.withAlphaComponent(0.1)
        
       
        let yearLabel = UILabel()
        yearLabel.text = "\(period.year)"
        yearLabel.font = UIFont(name: "Avenir Next-Bold", size: 22)
        yearLabel.textColor = period.gender.rawValue == "boy" ? .systemBlue: .systemPink
        yearLabel.textAlignment = .center
        stackView.addArrangedSubview(yearLabel)
        
       
        let calendarImageView = UIImageView()
        calendarImageView.contentMode = .scaleAspectFit
        calendarImageView.image = period.gender.rawValue == "boy" ? UIImage(named: "blueCalendar"): UIImage(named: "pinkCalendar")
        calendarImageView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        stackView.addArrangedSubview(calendarImageView)
        
      
        let dayLabel = UILabel()
        dayLabel.text = "\(period.day)"
        dayLabel.font = UIFont(name: "Avenir Next-Bold", size: 20)
        dayLabel.textColor = period.gender.rawValue == "boy" ? .systemBlue : .systemPink
        dayLabel.textAlignment = .center
        stackView.addArrangedSubview(dayLabel)
        
       
        let monthLabel = UILabel()
        monthLabel.text = "\(period.month)"
        monthLabel.font = UIFont(name: "Avenir Next-Bold", size: 20)
        monthLabel.textColor = period.gender.rawValue == "boy" ? .systemBlue : .systemPink
        monthLabel.textAlignment = .center
        stackView.addArrangedSubview(monthLabel)
        
      
        let infoButton = UIButton(type: .infoLight)
        infoButton.tintColor = period.gender.rawValue == "boy" ? .systemBlue : .systemPink
        containerView.addSubview(infoButton)
        
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            infoButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        infoButton.tag = indexOfTheCarousel
        
        infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
        
        return containerView
    }
    
    @objc func infoButtonTapped(_ sender: UIButton) {
        if toolTip != nil {
            toolTip?.removeFromSuperview()
            toolTip = nil
            return
        }
       
        
        let index = sender.tag
        let period = items[index]
        toolTip = Tooltip(text: NSLocalizedString("In the Bebilendar cards below, you can see the estimate of when the change will occur, including the year, month, and day. Good luck!", comment: "tool tip info message"), gender: period.gender.rawValue)
        
        guard let toolTip = toolTip else { return }
        
        if let parentView = self.superview {
            parentView.addSubview(toolTip)
            toolTip.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                toolTip.bottomAnchor.constraint(equalTo: sender.topAnchor, constant: -10), // Above the button
                toolTip.centerXAnchor.constraint(equalTo: sender.centerXAnchor),          // Align horizontally with the button
                toolTip.leadingAnchor.constraint(greaterThanOrEqualTo: parentView.leadingAnchor, constant: 10), // Ensure tooltip doesn't overflow left
                toolTip.trailingAnchor.constraint(lessThanOrEqualTo: parentView.trailingAnchor, constant: -10)  // Ensure tooltip doesn't overflow right
            ])
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        toolTip?.removeFromSuperview()
        toolTip = nil
    }
}
