//
//  HeaderCollectionReusableView.swift
//  avito-test-2020
//
//  Created by Irek Khabibullin on 10/29/22.
//

import UIKit

final class HeaderReusableView: UICollectionReusableView {

    public static let identifier = "HeaderReusableView"
    private static let titleLineSpacing: CGFloat = 0.3
    private static let font = UIFont.systemFont(ofSize: 27.0, weight: .bold)
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .natural
        return label
    }()
    
    private static let labelParagraph: NSMutableParagraphStyle = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = HeaderReusableView.titleLineSpacing
        return paragraph
    }()
    
    static let attributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.paragraphStyle: HeaderReusableView.labelParagraph,
        NSAttributedString.Key.font: HeaderReusableView.font
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let titleHeight = titleLabel.attributedText?.height(
            withConstrainedWidth: MainView.cellWidth
        )
        
        titleLabel.frame = CGRect(
            x: 20, y: 0, width: MainView.cellWidth, height: titleHeight ?? 0
        )
    }
    
    public func configure(text: NSMutableAttributedString) {
        titleLabel.attributedText = text
    }
}
