//
//  OnboardingViewController.swift
//  Bebilator
//
//  Created by Vladimir Savic on 26.7.23..
//

import UIKit

class OnboardingViewController: UIViewController {
    
    let viewModel = OnboardingViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViewModel()
        
        
        viewModel.updateUI()
        
        
     
   
    }
    
    private func configureViewModel() {
        viewModel.onCurrentPageUpdated = { [weak self] title, currentPage in
            self?.pageControl.currentPage = currentPage
            self?.nextBtn.setTitle(title, for: .normal)
            
        }
    }
    


    

}



