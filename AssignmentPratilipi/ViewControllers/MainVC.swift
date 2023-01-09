//
//  MainVC.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 30/12/22.
//

import UIKit
import SwiftUI

class MainVC: LoadingVC, MainViewModelOutput {
    
    let viewModel: MainViewModel
    var objects: [Object] = []
    var objects2: [Object2] = []
    
//    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        viewModel.configureDataSource(collectionView: collectionView)
        getData()
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
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
        self.viewModel.output = self

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func getData() {
        viewModel.fetchData(view: self)
    /*    showLoadingView()
        if #available(iOS 16, *) {
            Task {
                do {
                    //top section
                    self.objects = try await NetworkManager.shared.getObjectsAsync(limit: 10)
                    //bottom section
                    self.objects2 = try await NetworkManager.shared.getObjects2Async()
                    self.updateData(objects: objects, objects2: objects2)
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
            //topSection
            NetworkManager.shared.getObjects(limit: 10) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let objects):
                    //bottomSection
                    NetworkManager.shared.getObjects2 { result in
                        self.dismissLoadingView()
                        switch result {
                        case .success(let objects2):
                            self.updateData(objects: objects, objects2: objects2)
                        case .failure(let failure):
                            self.dismissLoadingView()
                            print(failure)
                        }
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        }  */
    }
    
    func updateData(objects: [Object], objects2: [Object2]) {
        var snapshot = viewModel.dataSource.snapshot()
        snapshot.appendSections([.topSection, .bottomSection])
        snapshot.appendItems(objects, toSection: .topSection)
        snapshot.appendItems(objects2, toSection: .bottomSection)
        DispatchQueue.main.async {  self.viewModel.dataSource.apply(snapshot) }
    }

}




extension MainVC {
    func configureCollectionView() {
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        collectionView.register(topSectionCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.register(bottomSectionCell.self, forCellWithReuseIdentifier: "bottomCellID")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
//    func configureLayout() -> UICollectionViewCompositionalLayout {
//        let layout = UICollectionViewCompositionalLayout {
//            (sectionNumber, _) -> NSCollectionLayoutSection? in
//            if sectionNumber == 0 {
//               return MainVC.topSection()
//            }
//            else {
//               return MainVC.bottomSection()
//            }
//        }
//        return layout
//    }
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
