//
//  topSectionCell.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import Foundation

import SwiftUI
import UIKit

class topSectionCell: UICollectionViewCell {
    
    static let reuseID = "topSectionCell"
    let topImageView = CustomImageView(frame: .zero)
    let topImageLabel   = CustomBodyLabel(textAlignment: .left)
    let topImageSmallLabel = CustomSmallLabel(textAlignment: .left)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        topImageLabel.text = "Random Text too"
        topImageSmallLabel.text = "genre-comedy"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(object: Object) {
        topImageView.downloadImage(fromURL: object.avatarUrl)
       // topImageLabel.text = object.author
    }
    
    
    private func configure() {
        addSubviews(topImageView, topImageLabel, topImageSmallLabel)
       // let padding: CGFloat = 2
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topImageView.widthAnchor.constraint(equalToConstant: 145),
            topImageView.heightAnchor.constraint(equalTo: topImageView.widthAnchor, multiplier: 3/2),
            //topImageView.heightAnchor.constraint(equalToConstant: 210),
            
            topImageLabel.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 3),
            topImageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            topImageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topImageLabel.heightAnchor.constraint(equalToConstant: 20),
            topImageSmallLabel.topAnchor.constraint(equalTo: topImageLabel.bottomAnchor, constant: 3),
            topImageSmallLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            topImageSmallLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topImageSmallLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
