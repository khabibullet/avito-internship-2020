//
//  OfferCollectionViewCell.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "offerCell"
    
    let offerTitle: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    var offerIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let offerDescription: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    static var descriptionStyle: NSMutableParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = 19
        return paragraph
    }()
    
    let attributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.paragraphStyle: descriptionStyle,
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .light)
    ]
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let checkButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 27, weight: .bold, scale: .small)
        let image = UIImage.checkmark.withConfiguration(config)
        button.setImage(image, for: .normal)
        button.setImage(UIImage(), for: .disabled)
        button.tintColor = UIColor.Avito.blue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.Avito.cellGray
        contentView.layer.cornerRadius = 7
        
        contentView.addSubview(offerIcon)
        contentView.addSubview(checkButton)
        contentView.addSubview(offerTitle)
        contentView.addSubview(offerDescription)
        contentView.addSubview(priceLabel)
    }
    
    func setFrames() {
        let cellWidth = UIScreen.main.bounds.width - 40
        
        offerIcon.frame = CGRect(
            origin: CGPoint(x: bounds.minX,
                            y: bounds.minY),
            size: CGSize(width: cellWidth * 0.25,
                         height: cellWidth * 0.25))
        
        
        let titleSize = offerTitle.intrinsicContentSize
        let numOfTitleRows = ceil((titleSize.width + 20) / (cellWidth * 0.6))
        offerTitle.frame = CGRect(
            origin: CGPoint(x: offerIcon.frame.maxX,
                            y: bounds.minY + 6),
            size: CGSize(width: cellWidth * 0.6,
                         height: titleSize.height * numOfTitleRows + 16))
        
        
        let descriptionSize = offerDescription.intrinsicContentSize
        let numOfDescriptionRows = ceil(descriptionSize.width / (cellWidth * 0.6))
        offerDescription.frame = CGRect(
            origin: CGPoint(x: offerIcon.frame.maxX,
                            y: offerTitle.frame.maxY),
            size: CGSize(width: cellWidth * 0.6,
                         height: descriptionSize.height * numOfDescriptionRows))
        
        
        let priceLabelSize = priceLabel.intrinsicContentSize
        let numOfPriceRows = ceil(priceLabelSize.width / (cellWidth * 0.6))
        priceLabel.frame = CGRect(
            origin: CGPoint(x: offerIcon.frame.maxX,
                            y: offerDescription.frame.maxY),
            size: CGSize(width: cellWidth * 0.6,
                         height: priceLabelSize.height * numOfPriceRows + 20))
        
        
        checkButton.frame = CGRect(
            origin: CGPoint(x: offerTitle.frame.maxX,
                            y: bounds.minY),
            size: CGSize(width: cellWidth * 0.15,
                         height: offerIcon.frame.height))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let width = offerIcon.frame.width
                    + offerTitle.frame.width
                    + checkButton.frame.width
        let height = max(offerIcon.frame.height, offerTitle.frame.height
                                                + offerDescription.frame.height
                                                + priceLabel.frame.height + 16)
        return CGSize(width: width, height: height)
    }
    
    public func configure(offer: Offer) {
        offerTitle.text = offer.title
        checkButton.isEnabled = offer.isSelected
        offerDescription.attributedText = offer.description?.attributed(by: attributes)
        priceLabel.text = offer.price
        configureOfferIcon(imageData: offer.icon.image)
        setFrames()
    }
    
    func configureOfferIcon(imageData: Data?) {
        let margin = CGFloat(13)
        if let imageData = imageData,
           let image = UIImage(data: imageData) {
            offerIcon.image = image
                .withInset(UIEdgeInsets(
                    top: margin, left: margin,
                    bottom: margin, right: margin))
        } else {
            let image = UIImage(systemName: "questionmark")!
                .withInset(UIEdgeInsets(
                    top: margin, left: margin,
                    bottom: margin, right: margin))?
                .withBackground(color: .systemGray2)
            offerIcon.image = image
        }
    }
}

extension UIImage {

    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(
            width: self.size.width + insets.left * self.scale + insets.right * self.scale,
            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)

        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)

        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }
    
    func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
            
        guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
        defer { UIGraphicsEndImageContext() }
            
        let rect = CGRect(origin: .zero, size: size)
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
        ctx.draw(image, in: rect)
            
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
