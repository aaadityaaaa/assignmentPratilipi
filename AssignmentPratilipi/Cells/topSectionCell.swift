//
//  topSectionCell.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import Foundation


import UIKit

class topSectionCell: UICollectionViewCell {
    
    static let reuseID = "topSectionCell"
    let topImageView = CustomImageView(frame: .zero)
    let topImageLabel   = CustomBodyLabel(textAlignment: .center)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(object: Object) {
        topImageView.downloadImage(fromURL: object.download_url!)
        topImageLabel.text = object.author
    }
    
    
    private func configure() {
        addSubviews(topImageView, topImageLabel)
        let padding: CGFloat = 2
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            topImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            topImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            topImageView.heightAnchor.constraint(equalToConstant: 250),
            
            topImageLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 12),
            topImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            topImageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            topImageLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
