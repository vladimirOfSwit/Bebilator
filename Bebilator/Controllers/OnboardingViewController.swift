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
    
    var viewModel: OnboardingViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let viewModel = viewModel {
            pageControl.numberOfPages = viewModel.slides.count
            self.configureViewModel()
        }
    }
    
    private func configureViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.onCurrentPageUpdated = { [weak self] title, currentPage in
        guard let self = self else { return }
            
        self.pageControl.currentPage = currentPage
        self.nextBtn.setTitle(title, for: .normal)
        self.nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold) // Set your desired font here
                    
        let indexPath = IndexPath(item: currentPage, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        
        let currentPage = viewModel.getCurrentPage()
        if currentPage == viewModel.slides.count - 1 {
            presentHomeScreen()
        } else {
            viewModel.setCurrentPage(number: currentPage + 1)
        }
    }
    
    private func presentHomeScreen() {
        UserDefaults.standard.hasOnboarded = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let controller = storyboard.instantiateViewController(withIdentifier: "HomeNC") as? UINavigationController {
            let controller = storyboard.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        }
    }
    
 
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.slides.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
 
        if let slide = viewModel?.slides[indexPath.row] {
            cell.setup(slide)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let currentPage = Int(scrollView.contentOffset.x / width)
        viewModel?.setCurrentPage(number: currentPage)
    }
}
