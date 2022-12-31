//
//  CompositionalView.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import UIKit

class CompositionalHeader: UICollectionReusableView {
    var label = UILabel(text: "Specially selected for you", font: .boldSystemFont(ofSize: 25))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       addSubview(label)
        label.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
