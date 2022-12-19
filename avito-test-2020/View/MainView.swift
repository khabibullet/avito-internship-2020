//
//  MainView.swift
//  avito-test-2020
//
//  Created by Irek Khabibullin on 10/27/22.
//

import UIKit


final class MainView: UIView {

    static let cellWidth = UIScreen.main.bounds.width - 40
    
    private let stopButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named: "CloseIconTemplate"),
            style: .done, target: self, action: nil
        )
        button.tintColor = UIColor.black
        return button
    }()
    
    public let selectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7
        return button
    }()
    
    public var offersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addSubview(offersCollectionView)
        addSubview(selectionButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let collectionViewHeight = bounds.height - safeAreaInsets.top
        let buttonHeight = (collectionViewHeight - safeAreaInsets.bottom) * 0.1
        
        selectionButton.frame = CGRect(
            x: bounds.minX + 20, y: bounds.maxY - buttonHeight - 20,
            width: MainView.cellWidth, height: buttonHeight
        )
        
        offersCollectionView.frame = CGRect(
            x: 0, y: safeAreaInsets.top,
            width: bounds.width, height: collectionViewHeight
        )
        
        offersCollectionView.contentInset.bottom = buttonHeight + 40
    }
    
    public func configureNavigationBar(bar: UINavigationBar) {
        bar.topItem?.leftBarButtonItem = stopButton
        bar.barTintColor = .white
        bar.shadowImage = UIImage()
    }
    
    enum ButtonAppearance {
        case light
        case dark
    }
    
    public func configureSelectionButton(
        appearance: ButtonAppearance, title: String
    ) {
        selectionButton.setTitle(title, for: .normal)
        if appearance == .dark {
            selectionButton.setTitleColor(.white, for: .normal)
            selectionButton.backgroundColor = UIColor.Avito.blue
        } else {
            selectionButton.setTitleColor(UIColor.Avito.blue, for: .normal)
            selectionButton.backgroundColor = UIColor.Avito.lightBlue
        }
        selectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    }
}
