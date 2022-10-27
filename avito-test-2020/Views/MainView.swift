//
//  MainView.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/27/22.
//

import UIKit

final class MainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        setupOffersCollectionView()
    }
    
    func setupConstraints() {
        
    }
    
    func setupOffersCollectionView() {
        
    }
    
}
