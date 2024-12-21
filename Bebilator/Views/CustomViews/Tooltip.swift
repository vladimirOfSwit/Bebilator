//
//  Tooltip.swift
//  Bebilator
//
//  Created by Vladimir Savic on 20.12.24..
//

import UIKit

class Tooltip: UIView {
    private let label = UILabel()
    private let arrow = UIView()
    
    init(text: String, gender: String) {
        super.init(frame: .zero)
        setupTooltip(textOfTheTip: text, genderResult: gender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTooltip(textOfTheTip: String, genderResult: String) {
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 4
        
        label.text = textOfTheTip
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = genderResult.lowercased() == "boy" ? .systemBlue : .systemPink
        label.font = UIFont.systemFont(ofSize: 14)
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        
        arrow.backgroundColor = .white
        arrow.layer.shadowColor = UIColor.black.cgColor
        arrow.layer.shadowOpacity = 0.1
        arrow.layer.shadowOffset = CGSize(width: 0, height: 4)
        arrow.layer.shadowRadius = 4
        arrow.transform = CGAffineTransform(rotationAngle: .pi / 4)
        self.addSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 10),
            arrow.heightAnchor.constraint(equalToConstant: 10),
            arrow.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            arrow.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
