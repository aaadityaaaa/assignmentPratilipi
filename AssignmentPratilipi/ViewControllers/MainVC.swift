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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // i thought of passing these values in the initialiser of my viewModel but then only one function was using it so i left it.
        viewModel.megaFunc(collectionView: collectionView, vc: self)
        viewModel.configureCollectionView(collectionView: collectionView, navigationController: navigationController)
    }
    
    init() {
        super.init(collectionViewLayout: viewModel.configureLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}





