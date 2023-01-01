//
//  bottomSectionCell.swift
//  AssignmentPratilipi
//
//  Created by Aaditya Singh on 31/12/22.
//

import UIKit

class bottomSectionCell: UICollectionViewCell {
    let imageView = CustomImageView(frame: .zero)
    let nameLabel = UILabel(text: "Long Text with name", font: .systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "genre - comedy/romance", font: .systemFont(ofSize: 13))
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        companyLabel.textColor = .secondaryLabel
        imageView.backgroundColor = .purple
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 100)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4)])
        stackView.spacing = 6
        stackView.alignment = .top
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    func set(object: Object2) {
        imageView.downloadImage(fromURL: object.imageUrl)
       // topImageLabel.text = object.author
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
