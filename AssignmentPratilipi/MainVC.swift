//
//  MainVC.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 30/12/22.
//

import UIKit
import SwiftUI

class MainVC: UICollectionViewController {

    @StateObject private var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension MainVC {
    
    override func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}
