//
//  MainVC.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 30/12/22.
//

import UIKit
import SwiftUI

class MainVC: LoadingVC {
    
    @StateObject private var viewModel = MainViewModel()
    var objects: [Object] = []    
    var objects2: [Object2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupDiffableDataSource()
    }
    
    func configureCollectionView() {
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(topSectionCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.register(bottomSectionCell.self, forCellWithReuseIdentifier: "bottomCellID")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    enum AppSection {
        case topSection
        case bottomSection
    }
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { collectionView, indexPath, returnedObject -> UICollectionViewCell? in
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
    
    private func setupDiffableDataSource() {
        showLoadingView()
        collectionView.dataSource = diffableDataSource
        //for the header title above bottom section
        diffableDataSource.supplementaryViewProvider = . some({
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
            return header
        })
        if #available(iOS 16, *) {
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.appendSections([.topSection, .bottomSection])
            Task {
                do {
                    //top section
                    self.objects = try await NetworkManager.shared.getObjectsAsync(limit: 10)
                    snapshot.appendItems(objects, toSection: .topSection)
                    //bottom section
                    self.objects2 = try await NetworkManager.shared.getObjects2Async()
                    snapshot.appendItems(objects2, toSection: .bottomSection)
                    DispatchQueue.main.async { self.diffableDataSource.apply(snapshot) }
                    self.dismissLoadingView()
                    print("ASYNC AWAIT IS RUNNING")
                } catch {
                    self.dismissLoadingView()
                    print(error)
                }
            }
        }
        else {
            //this works for iOS13
            NetworkManager.shared.getObjects(limit: 10) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let objects):
                    NetworkManager.shared.getObjects2 { result in
                        self.dismissLoadingView()
                        switch result {
                        case .success(let objects2):
                            var snapshot = self.diffableDataSource.snapshot()
                            //topsection
                            snapshot.appendSections([.topSection, .bottomSection])
                            snapshot.appendItems(objects, toSection: .topSection)
                            //bottomsection
                            snapshot.appendItems(objects2, toSection: .bottomSection)
                            DispatchQueue.main.async {  self.diffableDataSource.apply(snapshot) }
                        case .failure(let failure):
                            self.dismissLoadingView()
                            print(failure)
                        }
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }
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
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(305), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension : .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)]
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension MainVC {
    
   /* override func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return objects.count
        } else {
            return objects2.count
        }
        
    } */
    
//    override func numberOfSections (in collectionView:
//        UICollectionView) -> Int {
//        return 0
//    }
    
   /* override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        
    } */
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! CompositionalHeader
//        header.label.text = "Specially Featured for you"
//        return header
//
//    }
    
}


