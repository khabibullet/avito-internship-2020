//
//  OfferCollectionViewCell.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "offerCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.Avito.cellGray
        contentView.layer.cornerRadius = 7
        contentView.addSubview(offerTitle)
        
        setConstraints()
    }
    
    func setConstraints() {
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            contentView.leftAnchor.constraint(equalTo: superview?.leftAnchor!)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let offerTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    public func configure(label: String) {
        offerTitle.text = label
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        offerTitle.text = nil
    }
}
