//
//  MainView.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/27/22.
//

import UIKit


final class MainView: UIView {

    static let cellWidth = UIScreen.main.bounds.width - 40
    
    let stopButton: UIBarButtonItem = {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(
                pointSize: 23, weight: .regular, scale: .small)
            let image = UIImage(systemName: "xmark", withConfiguration: config)
            let button = UIBarButtonItem(
                image: image, style: .done, target: self, action: nil
            )
            button.tintColor = UIColor.black
            return button
        } else {
            let button = UIBarButtonItem(
                image: UIImage(named: "CloseIconTemplate"),
                style: .done, target: self, action: nil
            )
            button.tintColor = UIColor.black
            return button
        }
    }()
    
    let selectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 7
        return button
    }()
    
    var offersCollectionView: UICollectionView = {
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
    
    func configureNavigationBar(bar: UINavigationBar) {
        bar.topItem?.leftBarButtonItem = stopButton
        bar.barTintColor = .white
        bar.shadowImage = UIImage()
    }
    
    func configureSelectionButton(offerIsSelected: Bool, actionTitle: String,
                                  selectedActionTitle: String) {
        if offerIsSelected {
            selectionButton.setTitle(selectedActionTitle, for: .normal)
            selectionButton.setTitleColor(.white, for: .normal)
            selectionButton.backgroundColor = UIColor.Avito.blue
        } else {
            selectionButton.setTitle(actionTitle, for: .normal)
            selectionButton.setTitleColor(UIColor.Avito.blue, for: .normal)
            selectionButton.backgroundColor = UIColor.Avito.lightBlue
        }
        selectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
    }
}
