//
//  BebilatorResultViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 30.11.23..
//
import UIKit


class BebilatorResultViewController: UIViewController, BebilatorGenderResultDelegate  {
    private let gifImageView = UIImageView()
    
    var genderResult = "" {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
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
    
    private func updateUI() {
        print("Gender result from updateUI() BebilatorResultViewController is \(genderResult)")
        if genderResult == "boy" {
            loadGif(name: "boy")
        } else {
            loadGif(name: "girl")
        }
        print("Result from delegate: \(genderResult)")
    }
    
    func didReceiveGenderResult(_ result: String) {
        print("Delegate method called with result: \(result)")
        genderResult = result
        if isViewLoaded {
            updateUI()
        }
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
