//
//  MainView.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/27/22.
//

import UIKit


final class MainView: UIView {

    weak var superVC: MainViewContoller?
    
    let stopButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(
            pointSize: 23, weight: .regular, scale: .small)
        let image = UIImage(systemName: "xmark",
                            withConfiguration: config)
        let button = UIBarButtonItem(image: image, style: .done,
                                     target: nil, action: nil)
        button.tintColor = .black
        return button
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
        return view
    }()
    
    init(frame: CGRect, superVC: MainViewContoller) {
        super.init(frame: frame)
        self.superVC = superVC
        self.backgroundColor = .white
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        superVC?.navigationItem.leftBarButtonItem = stopButton
        
        addSubview(offersCollectionView)
        addSubview(selectionButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let collectionViewHeight = bounds.height - safeAreaInsets.top
        let buttonHeight = (collectionViewHeight - safeAreaInsets.bottom) * 0.1
        
        selectionButton.frame = CGRect(
            x: bounds.minX + 20, y: bounds.maxY - buttonHeight - 20,
            width: bounds.width - 40, height: buttonHeight)
        
        offersCollectionView.frame = CGRect(
            x: 0, y: safeAreaInsets.top,
            width: bounds.width,
            height: collectionViewHeight)
        
        offersCollectionView.contentInset.bottom = buttonHeight + 40
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        let bar = superVC?.navigationController?.navigationBar
        bar?.standardAppearance = navBarAppearance
        bar?.scrollEdgeAppearance = navBarAppearance
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


extension UIColor {
    struct Avito {
        static var blue: UIColor {
            return UIColor(red: 1/255, green: 172/255,
                           blue: 1, alpha: 1)
        }
        static var cellGray: UIColor {
            return UIColor(red: 240/255, green: 240/255,
                           blue: 240/255, alpha: 1)
        }
        static var lightBlue: UIColor {
            return UIColor(red: 200/255, green: 231/255,
                           blue: 1, alpha: 1)
        }
    }
    
    func withBrightnessAdjustedTo(constant: CGFloat) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s,
                       brightness: min((b + constant), 1.0), alpha: a)
    }
}

extension String {
    func attributed(by attributes: [NSAttributedString.Key : Any]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = NSMakeRange(0, attributedString.length)
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
}
