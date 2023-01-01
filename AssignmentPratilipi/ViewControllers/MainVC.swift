//
//  MainVC.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 30/12/22.
//

import UIKit
import SwiftUI

class MainVC: LoadingVC {
    
    var viewModel = MainViewModel()
    var objects: [Object] = []    
    var objects2: [Object2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // i thought of passing these values in the initialiser of my viewModel but then only one function was using it so i left it.
        viewModel.configureCollectionView(collectionView: collectionView, navigationController: navigationController)
        setupDiffableDataSource()
    }
    
    init() {
        super.init(collectionViewLayout: viewModel.configureLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

}





