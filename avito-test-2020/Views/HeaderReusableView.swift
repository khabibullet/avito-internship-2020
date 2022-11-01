//
//  HeaderCollectionReusableView.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/29/22.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {

    static let identifier = "HeaderReusableView"
    static let lineSpacing: CGFloat = 0.3
    static let font = UIFont.boldSystemFont(ofSize: 27.0)
    static let labelVertiacalInsets: CGFloat = 70
    
    static let labelParagraph: NSMutableParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = HeaderReusableView.lineSpacing
        return paragraph
    }()
    
    static let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.paragraphStyle: HeaderReusableView.labelParagraph,
            NSAttributedString.Key.font: HeaderReusableView.font
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .natural
        label.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 150/255, alpha: 1)
        return label
    }()
    
    public func configure(text: NSMutableAttributedString) {
        titleLabel.attributedText = text
    }
}
