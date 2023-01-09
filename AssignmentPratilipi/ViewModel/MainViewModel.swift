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

protocol MainViewModelOutput: AnyObject {
    func updateData(objects: [Object], objects2: [Object2])
}

class MainViewModel{
    
    weak var output: MainViewModelOutput?
    private let objectService: ObjectService
    
    init(objectService: ObjectService) {
        self.objectService = objectService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var objects: [Object] = []
    var objects2: [Object2] = []
    
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
        
        dataSource.supplementaryViewProvider = . some({
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
            return header
        })
        
        collectionView.dataSource = self.dataSource
        
}
    
    func fetchData(view: LoadingVC) {
        view.showLoadingView()
        objectService.getObjects(limit: 10) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let objects):
                self.objectService.getObjects2 { [weak self] result in
                    guard let self = self else {return}
                   view.dismissLoadingView()
                    switch result {
                    case .success(let objects2):
                        self.output?.updateData(objects: objects, objects2: objects2)
                    case .failure(let error):
                        print("object2 failure \(error)")
                    }
                }
            case .failure(let error):
                print("object1 failure \(error)")
            }
        }
    }
    
    
}

enum AppSection {
    case topSection
    case bottomSection
}
