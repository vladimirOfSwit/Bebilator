//
//  StoreViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 9.4.25..
//

import UIKit
import StoreKit

class StoreViewController: UIViewController {
    private let storeKitManager = StoreKitManager()
    private var products: [Product] = []
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private var buyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProducts()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        
        buyButton = UIButton(type: .system)
        buyButton.setTitle("Buy 3 cuclas", for: .normal)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        buyButton.frame = CGRect(x: 200, y: 200, width: 200, height: 50)
        buyButton.isEnabled = false
        view.addSubview(buyButton)
    }
    
    private func loadProducts() {
        Task {
            do {
                loadingIndicator.startAnimating()
                try await storeKitManager.fetchProducts()
                await MainActor.run {
                    self.products = storeKitManager.products
                    print("Loaded products: \(self.products.map { $0.id })")
                    self.buyButton.isEnabled = true
                    self.loadingIndicator.stopAnimating()
                }
            } catch {
                await MainActor.run {
                    self.showAlert(title: "Error", message: "Failed to load products")
                    self.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    @objc private func buyButtonTapped() {
        print("Buy button tapped")
        guard let product = products.first else { return }
        
        Task {
            do {
                loadingIndicator.startAnimating()
                if let _ = try await storeKitManager.purchase(product) {
                    await MainActor.run {
                        self.navigationController?.popViewController(animated: true)
                        showAlert(title: "Success", message: "Purchase completed")
                        TryManager.shared.resetRemainingTries()
                    }
                }
            } catch {
                await MainActor.run {
                    showAlert(title: "Error", message: error.localizedDescription)
                }
            }
            loadingIndicator.stopAnimating()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
