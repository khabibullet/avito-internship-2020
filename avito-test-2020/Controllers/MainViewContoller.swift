//
//  ViewController.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit


protocol APIControllerDelegate {
    func getContents(contents: Contents)
}

final class MainViewContoller: UIViewController, APIControllerDelegate,
                               UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    var contents: Contents?
    var mainView: MainView { return self.view as! MainView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIController(delegate: self).getGeneralData()
        mainView.offersCollectionView.delegate = self
        mainView.offersCollectionView.dataSource = self
        mainView.offersCollectionView.register(OfferCollectionViewCell.self,
            forCellWithReuseIdentifier: OfferCollectionViewCell.identifier)
    }
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds, superVC: self)
    }
    
    func getContents(contents: Contents) {
        self.contents = contents
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return contents?.offers.count ?? 0
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        let cell = mainView.offersCollectionView.dequeueReusableCell(
            withReuseIdentifier: OfferCollectionViewCell.identifier,
            for: indexPath) as! OfferCollectionViewCell
//            cell.configure(label: contents?.offers[indexPath.row].title ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainView.offersCollectionView.bounds.size.width - 40, height: CGFloat(100))
    }
}
