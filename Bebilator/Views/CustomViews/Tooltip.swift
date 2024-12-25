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
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40)
        ])
        
        arrow.backgroundColor = .clear
        self.addSubview(arrow)
        arrow.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrow.widthAnchor.constraint(equalToConstant: 20),
            arrow.heightAnchor.constraint(equalToConstant: 10),
            arrow.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            arrow.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        let arrowLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 20, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 10))
        path.close()
        
        arrowLayer.path = path.cgPath
        arrowLayer.fillColor = UIColor.white.cgColor
        arrow.layer.addSublayer(arrowLayer)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width - 40)
        ])
    }
    
    func adjustPosition(forParentView parent: UIView, relativeTo target: UIView) {
        parent.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: target.topAnchor, constant: -10),
            self.centerXAnchor.constraint(equalTo: target.centerXAnchor),
            self.leadingAnchor.constraint(greaterThanOrEqualTo: parent.leadingAnchor, constant: 10),
            self.trailingAnchor.constraint(lessThanOrEqualTo: parent.trailingAnchor, constant: -10)
        ])
    }
}
