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
    
    var offerIcon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 230/255, alpha: 1)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let offerDescription: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let emptyView = UIView()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(.checkmark, for: .normal)
        button.setImage(UIImage(), for: .disabled)
        button.tintColor = UIColor.Avito.blue
        button.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 230/255, alpha: 1)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    
//    let verticalStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        return stack
//    }()
    
//    let horizontalStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        return stack
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.Avito.cellGray
        contentView.layer.cornerRadius = 7
        let width = UIScreen.main.bounds.size.width - 40
        
        contentView.addSubview(offerIcon)
//        contentView.addSubview(verticalStack)
        contentView.addSubview(checkButton)
        
        contentView.addSubview(offerTitle)
        contentView.addSubview(offerDescription)
        contentView.addSubview(priceLabel)
        contentView.addSubview(emptyView)
        
        
//        verticalStack.addArrangedSubview(offerTitle)
//        verticalStack.addArrangedSubview(offerDescription)
//        verticalStack.addArrangedSubview(priceLabel)
        
        offerIcon.translatesAutoresizingMaskIntoConstraints = false
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        
        offerTitle.translatesAutoresizingMaskIntoConstraints = false
        offerDescription.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
//        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: width),
            
            offerTitle.leftAnchor.constraint(equalTo: offerIcon.rightAnchor),
            offerTitle.rightAnchor.constraint(equalTo: checkButton.leftAnchor),
            offerDescription.leftAnchor.constraint(equalTo: offerIcon.rightAnchor),
            offerDescription.rightAnchor.constraint(equalTo: checkButton.leftAnchor),
            priceLabel.leftAnchor.constraint(equalTo: offerIcon.rightAnchor),
            priceLabel.rightAnchor.constraint(equalTo: checkButton.leftAnchor),
            emptyView.leftAnchor.constraint(equalTo: offerIcon.rightAnchor),
            emptyView.rightAnchor.constraint(equalTo: checkButton.leftAnchor),
            
            offerTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            offerDescription.topAnchor.constraint(equalTo: offerTitle.bottomAnchor),
            priceLabel.topAnchor.constraint(equalTo: offerDescription.bottomAnchor),
            emptyView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            emptyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            offerIcon.widthAnchor.constraint(equalToConstant: width * 0.25),
            offerIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor),

            checkButton.widthAnchor.constraint(equalToConstant: width * 0.2),
            checkButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),

//            verticalStack.leftAnchor.constraint(equalTo: offerIcon.rightAnchor),
//            verticalStack.rightAnchor.constraint(equalTo: checkButton.leftAnchor),
//            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
//            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    public func configure(offer: Offer) {
        offerTitle.text = offer.title
        checkButton.isEnabled = offer.isSelected
        offerDescription.text = offer.description
        priceLabel.text = offer.price
    }
}
