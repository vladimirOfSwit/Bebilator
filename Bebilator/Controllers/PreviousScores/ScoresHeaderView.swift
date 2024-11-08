//
//  ScoresHeaderView.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.10.24..
//

import UIKit

class ScoresHeaderView: UIView {
    private let mDateIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mIconTextfield")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let wDateIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "fIconTextfield")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let genderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "genderIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let nTextIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nIconTextfield")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [mDateIcon, wDateIcon, genderIcon, nTextIcon])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
}
