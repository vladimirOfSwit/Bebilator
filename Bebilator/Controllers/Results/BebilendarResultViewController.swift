//
//  BebilendarViewModel.swift
//  Bebilator
//
//  Created by Vladimir Savic on 4.11.24..
//

import Foundation
import UIKit

class BebilendarResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var collectionView: UICollectionView!
    var switchingPeriods: [(year: Int, month: Int, day: Int, gender: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
       
    }
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.showsHorizontalScrollIndicator = false
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}


