//
//  BebilendarViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit
import iCarousel

class BebilendarResultViewController: UIViewController, iCarouselDataSource {
    
    
    var viewModel = BebilendarResultViewModel()
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(viewModel.resultsCarousel)
        viewModel.resultsCarousel.dataSource = self
        viewModel.resultsCarousel.frame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: 400)
        
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        return switchingPeriods.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 1.4, height: 300))
        view.backgroundColor = .white
        
        let label = UILabel(frame: view.bounds)
        label.numberOfLines = 0
        label.textAlignment = .center
        let period = switchingPeriods[index]
        label.text = "Godina: \(period.year), Mesec: \(period.month), Dan: \(period.day), Pol: \(period.gender)"
        
        view.addSubview(label)
        
        return view
    }
}


