//
//  CarouselCell.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import UIKit

class CarouselCell: UICollectionViewCell {
    static let identifier = "CarouselCell"
    
    private let yearLabel = UILabel()
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    private let genderIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            setupCell()
        }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupCell() {
        yearLabel.font = UIFont(name: "SF Pro Medium", size: 14)
        monthLabel.font = UIFont(name: "SF Pro Medium", size: 14)
        dayLabel.font = UIFont(name: "SF Pro Medium", size: 14)
        genderIcon.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [yearLabel, monthLabel, dayLabel, genderIcon])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    func configure(with period: (year: Int, month: Int, day: Int, gender: String)) {
        yearLabel.text = "Godina: \(period.year)"
        monthLabel.text = "Mesec: \(period.month)"
        dayLabel.text = "Dan: \(period.day)"
        genderIcon.image = UIImage(named: period.gender == "boy" ? "blueBabyIcon" : "pinkBabyIcon")
    }
}
