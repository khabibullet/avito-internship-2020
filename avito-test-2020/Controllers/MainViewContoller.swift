//
//  ViewController.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit

//protocol APIControllerDelegate {
//    func setContents(contents: Contents)
//    func setImageData(data: Data, index: Int)
//    func presentAlert(alert: UIAlertController)
//}

final class MainViewContoller: UIViewController,
                               UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    var contents: Contents?
    var mainView: MainView { return self.view as! MainView }
    var networkManager: APIController
    
    init(networkManager: APIController) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getGeneralData(destination: self)
        networkManager.loadIconImages(of: contents?.offers, to: self)
        
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
    
    func setContents(contents: Contents) {
        self.contents = contents
    }
    
    func setImageData(data: Data, index: Int) {
        self.contents?.offers[index].icon.image = data
    }
    
    func presentAlert(alert: UIAlertController) {
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
        
        let attributedText = (contents?.title ?? "").attributed(by: HeaderReusableView.attributes)
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
        return CGSize(width: size.width, height: size.height + HeaderReusableView.labelVerticalPadding)
    }
}
