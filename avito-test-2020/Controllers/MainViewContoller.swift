//
//  ViewController.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit

final class MainViewContoller: UIViewController,
                               UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    var contents: Contents?
    var mainView: MainView { return self.view as! MainView }
    let networkManager: APIController
    var currentSelectedOfferId: Int?
    @objc dynamic var isAnyOfferSelected: Bool = true
    
    var offersSelectionObservation: NSKeyValueObservation?
    
    init(networkManager: APIController) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
        
        networkManager.getGeneralData(destination: self)
        networkManager.loadIconImages(of: contents?.offers, to: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonsUnchecked()
        
        mainView.offersCollectionView.delegate = self
        mainView.offersCollectionView.dataSource = self
        
        mainView.offersCollectionView.register(OfferCollectionViewCell.self,
            forCellWithReuseIdentifier: OfferCollectionViewCell.identifier)
        mainView.offersCollectionView.register(HeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier)
        
        offersSelectionObservation = observe(\MainViewContoller.isAnyOfferSelected,
            options: [.new, .old]) { [weak self] vc, change in
            
            guard let new = change.newValue, let old = change.oldValue else { return }
            if new != old {
                self?.mainView.configureSelectionButton(
                    offerIsSelected: new, actionTitle: self?.contents?.actionTitle ?? "",
                    selectedActionTitle: self?.contents?.selectedActionTitle ?? "")
            }
        }
        
        isAnyOfferSelected = false
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
    
    func setButtonsUnchecked() {
        if contents != nil {
            for (index, _) in contents!.offers.enumerated() {
                contents!.offers[index].isSelected = false
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let isSelected = contents?.offers[indexPath.row].isSelected else { return }
        
        if isSelected {
            contents?.offers[indexPath.row].isSelected = false
            currentSelectedOfferId = nil
            isAnyOfferSelected = false
        } else {
            contents?.offers[indexPath.row].isSelected = true
            if let id = currentSelectedOfferId {
                contents?.offers[id].isSelected = false
            }
            currentSelectedOfferId = indexPath.row
            isAnyOfferSelected = true
        }
        mainView.offersCollectionView.reloadData()
    }
}
