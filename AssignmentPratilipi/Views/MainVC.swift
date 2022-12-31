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
    var objects2: [Object] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind:
                                    UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(topSectionCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.register(bottomSectionCell.self, forCellWithReuseIdentifier: "bottomCellID")
        navigationController?.navigationBar.prefersLargeTitles = true
        getObjects()
        getObjects2()
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

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(2), heightDimension: .absolute(320)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    static func bottomSection() -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(295), heightDimension: .absolute(120)))
        item.contentInsets = .init(top: 0, leading: 10, bottom: 16, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(305), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension : .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)]
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getObjects() {
        NetworkManager.shared.getObjects(page: 3, limit: 10) { result in
            switch result {
            case .success(let objects):
                DispatchQueue.main.async {
                    self.objects = objects
                    self.collectionView.reloadData()
                }
               
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func getObjects2() {
        NetworkManager.shared.getObjects(page: 3, limit: 3) { result in
            switch result {
            case .success(let objects):
                DispatchQueue.main.async {
                    self.objects2 = objects
                    self.collectionView.reloadData()
                }
               
            case .failure(let failure):
                print(failure)
            }
        }
    }
   
    
}


extension MainVC {
    
    override func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return objects.count
        } else {
            return objects2.count
        }
        
    }
    
    override func numberOfSections (in collectionView:
        UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! topSectionCell
            let object = self.objects[indexPath.item]
            cell.set(object: object)
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bottomCellID", for: indexPath) as! bottomSectionCell
            //cell.backgroundColor = .blue
            let object2 = self.objects2[indexPath.item]
            cell.set(object: object2)
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView { return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
        
    }
    
}


