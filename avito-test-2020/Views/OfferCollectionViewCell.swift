//
//  OfferCollectionViewCell.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "offerCell"
    
    private let offerTitle: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.Avito.cellGray
        contentView.layer.cornerRadius = 7
        contentView.addSubview(offerTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        offerTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            offerTitle.leftAnchor.constraint(equalTo: self.leftAnchor),
            offerTitle.rightAnchor.constraint(equalTo: self.rightAnchor),
            offerTitle.topAnchor.constraint(equalTo: self.topAnchor),
            offerTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func configure(label: String) {
        offerTitle.text = label
    }
}
