//
//  MainViewModel.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 30/12/22.
//

import Foundation
import UIKit

enum AppSection {
    case topSection
    case bottomSection
}

struct MainViewModel {
 
    func configureCollectionView(collectionView: UICollectionView, navigationController: UINavigationController?) {
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(topSectionCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.register(bottomSectionCell.self, forCellWithReuseIdentifier: "bottomCellID")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionNumber, _) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
               return MainViewModel.topSection()
            }
            else {
               return MainViewModel.bottomSection()
            }
        }
        return layout
    }
    //MARK:- top section
    static func topSection() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1/5), heightDimension: .fractionalHeight(0.9)))
        item.contentInsets.top = 16
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 0
        item.contentInsets.leading = 10

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(2), heightDimension: .absolute(320)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    static func bottomSection() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(295), heightDimension: .absolute(120)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 10)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(305), heightDimension: .absolute(300)), subitems: [item])
        
//MARK:- custom group method example
        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
//        let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize, itemProvider: { (index: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutItem in
//                return item
//            })
        
//        let group2 = NSCollectionLayoutGroup.custom(layoutSize: .init(widthDimension: .fractionalWidth(1.5), heightDimension: .fractionalHeight(2))) { NSCollectionLayoutEnvironment in
//            
//        }
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension : .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)]
        return section
    }
    
}
