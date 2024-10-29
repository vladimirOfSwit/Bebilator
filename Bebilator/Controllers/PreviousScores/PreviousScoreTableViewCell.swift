//
//  PreviousScoreTableViewCell.swift
//  Bebilator
//
//  Created by Vladimir Savic on 29.10.24..
//

import UIKit

class PreviousScoreTableViewCell: UITableViewCell {
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
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(mTextLabel)
        contentView.addSubview(wTextLabel)
        contentView.addSubview(genderIcon)
        contentView.addSubview(nTextLabel)
        
        NSLayoutConstraint.activate([
            mTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            wTextLabel.leadingAnchor.constraint(equalTo: mTextLabel.trailingAnchor, constant: 8),
            wTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            genderIcon.leadingAnchor.constraint(equalTo: wTextLabel.trailingAnchor, constant: 8),
            genderIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            genderIcon.widthAnchor.constraint(equalToConstant: 20),
            genderIcon.heightAnchor.constraint(equalToConstant: 20),
            
            nTextLabel.leadingAnchor.constraint(equalTo: genderIcon.trailingAnchor, constant: 8),
            nTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            
        ])
    }
    func configure(with mText: String, wText: String, gender: String, nText: String) {
        mTextLabel.text = mText
        wTextLabel.text = wText
        nTextLabel.text = nText
        
        if gender.lowercased() == "boy" {
            mTextLabel.textColor = UIColor(hex: "#6B92E5")
            wTextLabel.textColor = UIColor(hex: "#6B92E5")
            nTextLabel.textColor = UIColor(hex: "#6B92E5")
            genderIcon.image = UIImage(named: "pinkBabyIcon")
        } else if gender.lowercased() == "girl" {
            mTextLabel.textColor = UIColor(hex: "##F88AB0")
            wTextLabel.textColor = UIColor(hex: "##F88AB0")
            nTextLabel.textColor = UIColor(hex: "##F88AB0")
            genderIcon.image = UIImage(named: "pinkBabyIcon")
        }
    }
}
