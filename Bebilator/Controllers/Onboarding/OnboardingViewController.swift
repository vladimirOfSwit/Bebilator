//
//  OnboardingViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 5.3.25..
//

import UIKit

class OnboardingViewController: UIViewController {
    var viewModel = OnboardingViewModel()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageControl: GradientPageControl = {
        let pc = GradientPageControl()
        pc.numberOfPages = 3 // Or however many pages you have
        pc.currentPage = 0
        pc.pageIndicatorTintColor = UIColor.lightGray // Color for inactive dots
        pageControl.startColor = UIColor(hex: "#6B92E5") ?? .systemRed
        pageControl.endColor = UIColor(hex: "#F88AB0") ?? .systemGray
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private let nextButton: GradientButton = {
        let button = GradientButton()
        button.startColor = UIColor(hex: "#6B92E5") ?? .systemBlue
        button.endColor = UIColor(hex: "#F88AB0") ?? .systemPink
        button.setTitle("Dalje", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 165),
            nextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
    }
    
    private func setupBindings() {
        
        pageControl.numberOfPages = viewModel.slides.count
        viewModel.onCurrentPageUpdated = {[weak self] title, currentPage in
            guard let self = self else { return }
            self.pageControl.currentPage = currentPage
            self.nextButton.setTitle(title, for: .normal)
            
            let indexPath = IndexPath(item: currentPage, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc private func nextButtonClicked() {
        let currentPage = viewModel.getCurrentPage()
        
        if currentPage == viewModel.slides.count - 1 {
            presentHomeScreen()
        } else {
            viewModel.setCurrentPage(number: currentPage + 1)
        }
    }
    
    private func presentHomeScreen() {
        UserDefaults.standard.hasOnboarded = true
        let homeVC = UINavigationController(rootViewController: WelcomeViewController())
        homeVC.modalPresentationStyle = .fullScreen
        homeVC.modalTransitionStyle = .flipHorizontal
        present(homeVC, animated: true)
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        let slide = viewModel.slides[indexPath.row]
        cell.setup(slide)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / width)
        viewModel.setCurrentPage(number: currentPage)
    }
}
