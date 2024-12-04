//
//  LoadingViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 8.11.24..
//

import UIKit
import ImageIO

class LoadingViewController: UIViewController {
    var backgroundImage: UIImageView?
    var onLoadingComplete: (() -> Void)?
    let viewModel = LoadingScreenViewModel()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let gradientLayer = viewModel.createGradientLayer(for: view.bounds)
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(gifImageView)
        
        NSLayoutConstraint.activate([
            gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gifImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gifImageView.widthAnchor.constraint(equalToConstant: 200),
            gifImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        loadGifImage(named: "loader")
    }
    
    func loadGifImage(named name: String) {
        guard let gifPath = Bundle.main.path(forResource: name, ofType: "gif"),
              let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)) else { return }
        gifImageView.image = UIImage.gifImageWithData(gifData)
    }
    
    func showLoadingScreen(for seconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [ weak self ] in
           self?.onLoadingComplete?()
            }
        }
    }

