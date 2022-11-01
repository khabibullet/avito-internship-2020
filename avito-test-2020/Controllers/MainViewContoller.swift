//
//  ViewController.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit


protocol APIControllerDelegate {
    func getContents(contents: Contents)
    func showError(alert: UIAlertController)
}

final class MainViewContoller: UIViewController, APIControllerDelegate,
                               UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    var contents: Contents?
    var mainView: MainView { return self.view as! MainView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIController(delegate: self).getGeneralData()
        
        contents?.offers[3].title = "oops"
        
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
    
    func showError(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Collection View configuration
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents?.offers.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
        let cell = mainView.offersCollectionView.dequeueReusableCell(
            withReuseIdentifier: OfferCollectionViewCell.identifier, for: indexPath)
            as! OfferCollectionViewCell
        
        guard let offer = contents?.offers[indexPath.row] else { return cell }
        APIController(delegate: self).loadImage(from: offer.icon.url, to: cell)
        cell.configure(offer: offer)
            
        return cell
    }
    
    
    // MARK: Collection View Header configuration
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier, for: indexPath) as! HeaderReusableView
        
        let attributedText = mainView.attributedStringFrom(text: contents?.title ?? "")
        header.configure(text: attributedText)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = UIScreen.main.bounds.width - 40
        let rect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let text = NSString(string: contents?.title ?? "")
        let size = text.boundingRect(with: rect, options: [.usesLineFragmentOrigin],
            attributes: HeaderReusableView.attributes, context: nil)
        return CGSize(width: size.width, height: size.height + HeaderReusableView.labelVertiacalInsets)
    }
}
