//
//  OnboardingViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 16.7.24..
//

import UIKit


class OnboardingViewModel: UIViewController {
    
    let viewController = OnboardingViewController()
    
    var slides: [OnboardingSlide] = []

    var onCurrentPageUpdated: ((String, Int) -> ())?

    private var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                self.onCurrentPageUpdated?("Kraj", currentPage)
                let controller = storyboard?.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .flipHorizontal
                UserDefaults.standard.hasOnboarded = true
                present(controller, animated: true)
            } else {
                self.onCurrentPageUpdated?("Dalje", currentPage)
                currentPage += 1
                let indexPath = IndexPath(item: currentPage, section: 0)
                viewController.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func getCurrentPage() -> Int {
        return self.currentPage
    }
    
    func setCurrentPage(number: Int) {
        self.currentPage = number
    }
    
    func updateUI() {
       slides = [OnboardingSlide(description: "Test prvi ekran", image: #imageLiteral(resourceName: "itsaboy")),
                 OnboardingSlide(description: "Test drugi ekran", image: #imageLiteral(resourceName: "itsagirl")),
                 OnboardingSlide(description: "Test treci ekran", image: #imageLiteral(resourceName: "boygirl"))
       ]
    }
}


extension OnboardingViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell

        cell.setup(slides[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)

    }


}
