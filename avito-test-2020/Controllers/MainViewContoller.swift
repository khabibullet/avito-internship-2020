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
        mainView.offersCollectionView.register(HeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier)
    }
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds, superVC: self)
    }
    
    func getContents(contents: Contents) {
        self.contents = contents
    }
    
    
    // MARK: Collection View configuration
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents?.offers.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        let cell = mainView.offersCollectionView.dequeueReusableCell(
            withReuseIdentifier: OfferCollectionViewCell.identifier,
            for: indexPath) as! OfferCollectionViewCell
        cell.configure(label: (contents?.offers[indexPath.row].title ?? "") + (contents?.offers[indexPath.row].title ?? ""))
        return cell
    }
    
    
    // MARK: Collection View Cell configuration
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainView.offersCollectionView.bounds.size.width - 40, height: CGFloat(100))
    }
    
    
    // MARK: Collection View Header configuration
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier, for: indexPath) as! HeaderReusableView
        header.configure(labelText: contents?.title ?? "")
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let approximateWidthOfHeader = mainView.offersCollectionView.bounds.size.width - 40
        
        let size = CGSize(width: approximateWidthOfHeader, height: 1000)
        
        let attributes = [NSAttributedString: UIFont.systemFont(ofSize: 27)]
        
        let estimatedFrame = NSString(string: contents?.title ?? "").boundingRect(
            with: size, options: .usesLineFragmentOrigin,
            attributes: <#T##[NSAttributedString.Key : Any]?#>, context: <#T##NSStringDrawingContext?#>)
        
        return CGSize(width: mainView.offersCollectionView.bounds.size.width - 40, height: 100)
    }
}
