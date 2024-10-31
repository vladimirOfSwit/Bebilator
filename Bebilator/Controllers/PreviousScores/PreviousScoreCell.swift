//
//  PreviousScoreCell.swift
//  Bebilator
//
//  Created by Vladimir Savic on 29.10.24..
//

import UIKit

class PreviousScoreCell: UITableViewCell {
    private let mTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let wTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let genderIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let nTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SF Pro Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        stackView.addArrangedSubview(mTextLabel)
        stackView.addArrangedSubview(wTextLabel)
        stackView.addArrangedSubview(genderIcon)
        stackView.addArrangedSubview(nTextLabel)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    func configure(with mText: String, wText: String, gender: String, nText: String) {
        mTextLabel.text = mText
        wTextLabel.text = wText
        nTextLabel.text = nText
        mTextLabel.textColor = UIColor(hex: "#6B92E5")
        wTextLabel.textColor = UIColor(hex: "#F88AB0")
        nTextLabel.textColor = UIColor(hex: "#7B81BE")
        if gender.lowercased() == "boy" {
            genderIcon.image = UIImage(named: "blueBabyIcon")
        } else if gender.lowercased() == "girl" {
            genderIcon.image = UIImage(named: "pinkBabyIcon")
        }
    }
}
