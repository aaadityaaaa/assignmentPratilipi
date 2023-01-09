//
//  MainViewModel.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 30/12/22.
//

import Foundation
import UIKit


protocol MainViewDelegate {
    
    func configureCollectionView(collectionView: UICollectionView, navigationController: UINavigationController?)
    
    func topSection() -> NSCollectionLayoutSection?
    func bottomSection() -> NSCollectionLayoutSection?
    
}

enum AppSection {
    case topSection
    case bottomSection
}

class MainViewModel {
    
    var dataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable>!

    func configureDataSource(collectionView: UICollectionView) {
    dataSource = UICollectionViewDiffableDataSource<AppSection, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, returnedObject) -> UICollectionViewCell? in
        if let returnedObject = returnedObject as? Object {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! topSectionCell
            cell.set(object: returnedObject)
            return cell
        }
        else if let returnedObject = returnedObject as? Object2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomCellID", for: indexPath) as! bottomSectionCell
            cell.set(object: returnedObject)
            return cell
        }
        return nil
    })
}
    
    
}
