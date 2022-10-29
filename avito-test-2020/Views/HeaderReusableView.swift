//
//  HeaderCollectionReusableView.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/29/22.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
        
    static let identifier = "HeaderReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .yellow
        return label
    }()
    
    public func configure(labelText: String) {
        titleLabel.text = labelText
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10),
        ])
    }
}
