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
    var objects: [Object] = []    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemGray5
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    init() {
       
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionNumber, _) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
               return MainVC.topSection()
            }
            else {
               return MainVC.bottomSection()
            }
        }
        super.init(collectionViewLayout: layout)
        
    }

    
    static func topSection() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(0.9)))
        item.contentInsets.top = 16
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 0
        item.contentInsets.leading = 10

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(2), heightDimension: .absolute(280)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    static func bottomSection() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(295), heightDimension: .absolute(140)))
        item.contentInsets = .init(top: 0, leading: 10, bottom: 16, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(305), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    
}


extension MainVC {
    
    override func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        } else {
            return 3
        }
        
    }
    override func numberOfSections (in collectionView:
        UICollectionView) -> Int {
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}
