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

class  MainViewModel {
 
    var objects: [Object] = []
    var objects2: [Object2] = []
    
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
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension : .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)]
        return section
    }
    
    func megaFunc(collectionView: UICollectionView, vc: LoadingVC) {
        lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: collectionView) { collectionView, indexPath, returnedObject -> UICollectionViewCell? in
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
        }
        
        setupDiffableDataSource(collectionView: collectionView, vc: vc, diffableDataSource: diffableDataSource)
    }
    
    public func setupDiffableDataSource(collectionView: UICollectionView, vc: LoadingVC, diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable>) {
        vc.showLoadingView()
        collectionView.dataSource = diffableDataSource
        //for the header title above bottom section
        diffableDataSource.supplementaryViewProvider = . some({
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
            return header
        })
        
      /*  if #available(iOS 16, *) {
            var snapshot = diffableDataSource.snapshot()
            snapshot.appendSections([.topSection, .bottomSection])
            Task {
                do {
                    //top section
                    self.objects = try await NetworkManager.shared.getObjectsAsync(limit: 10)
                    snapshot.appendItems(objects, toSection: .topSection)
                    //bottom section
                    self.objects2 = try await NetworkManager.shared.getObjects2Async()
                    snapshot.appendItems(objects2, toSection: .bottomSection)
                    DispatchQueue.main.async { diffableDataSource.apply(snapshot) }
                    await vc.dismissLoadingView()
                    print("ASYNC AWAIT IS RUNNING")
                } catch {
                    await vc.dismissLoadingView()
                    print(error)
                }
            }
        } */
       // else {
            //this works for iOS13
            NetworkManager.shared.getObjects(limit: 10) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let objects):
                    NetworkManager.shared.getObjects2 { result in
                       vc.dismissLoadingView()
                        switch result {
                        case .success(let objects2):
                            var snapshot = diffableDataSource.snapshot()
                            //topsection
                            snapshot.appendSections([.topSection, .bottomSection])
                            snapshot.appendItems(objects, toSection: .topSection)
                            //bottomsection
                            snapshot.appendItems(objects2, toSection: .bottomSection)
                            DispatchQueue.main.async {  diffableDataSource.apply(snapshot) }
                        case .failure(let failure):
                           vc.dismissLoadingView()
                            print(failure)
                        }
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
      //  }
    }
}
