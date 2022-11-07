//
//  MainView.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/27/22.
//

import UIKit


final class MainView: UIView {

    weak var superVC: MainViewContoller?
    
    init(frame: CGRect, superVC: MainViewContoller) {
        super.init(frame: frame)
        self.superVC = superVC
        
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
        
        
        
        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectionButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            selectionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            selectionButton.heightAnchor.constraint(equalToConstant: self.frame.size.height * 0.075),
            selectionButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        offersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            offersCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            offersCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            offersCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 45),
            offersCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        offersCollectionView.contentInset.bottom = 100
    }
    
    let stopButton: UIBarButtonItem = {
//        let button = UIBarButtonItem(
//            barButtonSystemItem: .stop,
//            target: nil,
//            action: nil)
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
        button.setTitle("Выбрать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.Avito.blue
        button.layer.cornerRadius = 7
        return button
    }()
    
    var offersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        view.alwaysBounceVertical = true
        return view
    }()
}


extension UIColor {
    struct Avito {
        static var blue: UIColor {
            return UIColor(red: 1/255, green: 172/255,
                           blue: 1, alpha: 1)
        }
        static var cellGray: UIColor {
            return UIColor(red: 248/255, green: 248/255,
                           blue: 248/255, alpha: 1)
        }
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
