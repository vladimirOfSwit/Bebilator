//
//  BebilatorResultViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.11.23..
//
import UIKit


class BebilatorResultViewController: UIViewController {
    private let gifImageView = UIImageView()
    
    var genderResult = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if genderResult == "boy" {
            loadGif(name: "boy")
        } else {
            loadGif(name: "girl")
        }
    }
    
    private func setupUI() {
        gifImageView.contentMode = .scaleAspectFit
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gifImageView)
        
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    func loadGif(name: String) {
        guard let gifPath = Bundle.main.path(forResource: name, ofType: "gif") else {
            return
        }
        guard let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)) else {
            return
        }
        guard let gifImage = UIImage.gifImageWithData(gifData) else {
            return
        }
        self.gifImageView.image = gifImage
    }
}
