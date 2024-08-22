//
//  OnboardingViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 26.7.23..
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var viewModel = OnboardingViewModel()
    private var numberOfClicks = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewModel.fetchSlides()
        pageControl.numberOfPages = viewModel.slides.count
        
        self.configureViewModel()
    }
    
    private func configureViewModel() {
        viewModel.onCurrentPageUpdated = { [weak self] title, currentPage in
        self?.pageControl.currentPage = currentPage
        self?.nextBtn.setTitle(title, for: .normal)
            
        let indexPath = IndexPath(item: currentPage, section: 0)
        self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        if title == "Kraj" {
        self?.presentHomeScreen()
            }
        }
    }
    
    private func presentHomeScreen() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "HomeNC") as? UINavigationController {
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        
        numberOfClicks += 1
        
        viewModel.setCurrentPage(number: numberOfClicks)
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.setup(viewModel.slides[indexPath.row])
        
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
