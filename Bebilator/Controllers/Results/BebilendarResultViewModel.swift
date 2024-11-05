//
//  BebilendarResultViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 5.11.24..
//

import iCarousel
import UIKit

class BebilendarResultViewModel {
    let resultsCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .coverFlow
        return view
    }()
    
    
}

