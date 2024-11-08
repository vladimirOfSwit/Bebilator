//
//  LoadingViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 8.11.24..
//

import UIKit
import ImageIO

class LoadingViewController: UIViewController {
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 200),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        view.addSubview(gifImageView)
        NSLayoutConstraint.activate([
            gifImageView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            gifImageView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor),
            gifImageView.widthAnchor.constraint(equalToConstant: 100),
            gifImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        loadGifImage(named: "loader")
    }
    func loadGifImage(named name: String) {
        guard let gifPath = Bundle.main.path(forResource: name, ofType: "gif"),
              let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)) else { return }
        gifImageView.image = UIImage.gifImageWithData(gifData)
    }
    func showLoadingScreen(for seconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self ] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
