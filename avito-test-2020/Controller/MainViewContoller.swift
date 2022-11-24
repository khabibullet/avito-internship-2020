//
//  ViewController.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit

final class MainViewContoller: UIViewController {
    
    private var contents: Contents?
    private var mainView: MainView { return self.view as! MainView }
    private let networkManager: DataFetchable
    private var currentSelectedOfferId: Int?
    @objc private dynamic var isAnyOfferSelected: Bool = true
    private var offersSelectionObservation: NSKeyValueObservation?
    
    init(networkManager: DataFetchable) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
        
        loadContents()
        loadIcons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadContents() {
        let semaphore = DispatchSemaphore(value: 0)
        networkManager.fetchInitialData { (contents, error)  in
            if let contents = contents {
                self.contents = contents
            } else {
                self.presentAlert(
                    title: "Error", message: error,
                    completion: { _ in fatalError(error) }
                )
            }
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    private func loadIcons() {
        guard contents?.offers != nil else { return }

        let group = DispatchGroup()
        for (index, _) in contents!.offers.enumerated() {
            group.enter()
            DispatchQueue.global().async() {
                self.networkManager.getRawData(
                    iconURL: self.contents!.offers[index].icon.url) { data in
                    self.contents!.offers[index].icon.image = data
                }
                group.leave()
            }
        }
        group.wait()
    }
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if contents == nil { return }
        
        mainView.offersCollectionView.delegate = self
        mainView.offersCollectionView.dataSource = self
        mainView.offersCollectionView.delaysContentTouches = false
        mainView.offersCollectionView.register(OfferCollectionViewCell.self,
            forCellWithReuseIdentifier: OfferCollectionViewCell.identifier)
        mainView.offersCollectionView.register(HeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier)
        
        setCheckmarksUnchecked()
        addCheckmarksObservation()
        isAnyOfferSelected = false
        
        mainView.selectionButton.addTarget(
            self, action: #selector(selectionButtonTapped), for: .touchUpInside
        )
        
        if let bar = navigationController?.navigationBar {
            mainView.configureNavigationBar(bar: bar)
        }
    }
    
    private func setCheckmarksUnchecked() {
        if contents != nil {
            for (index, _) in contents!.offers.enumerated() {
                contents!.offers[index].isSelected = false
            }
        }
    }
    
    private func addCheckmarksObservation() {
        offersSelectionObservation = observe(\MainViewContoller.isAnyOfferSelected,
            options: [.new, .old]) { [weak self] vc, change in
            
            guard let new = change.newValue, let old = change.oldValue else { return }
            if new != old {
                self?.mainView.configureSelectionButton(
                    offerIsSelected: new, actionTitle: self?.contents?.actionTitle ?? "",
                    selectedActionTitle: self?.contents?.selectedActionTitle ?? ""
                )
            }
        }
    }
    
    @objc private func selectionButtonTapped() {
        var message = "\nПродолжить без изменений?"
        if isAnyOfferSelected {
            message = """
            \nВы выбрали услугу
            \"\(contents?.offers[currentSelectedOfferId ?? 0].title ?? "nil")\"
            """
        }
        presentAlert(title: "Подтвердить?", message: message, completion: nil)
    }
    
    private func presentAlert(title: String, message: String,
        completion: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title, message: message, preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(
                UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                handler: completion)
            )
            self.present(alert, animated: true, completion: nil)
        }
    }
}




// MARK: - OffersCollectionViewDataSource

extension MainViewContoller: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return contents?.offers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainView.offersCollectionView.dequeueReusableCell(
            withReuseIdentifier: OfferCollectionViewCell.identifier, for: indexPath)
            as! OfferCollectionViewCell
        
        guard let offer = contents?.offers[indexPath.row] else { return cell }
        cell.configureOfferCell(offer: offer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier, for: indexPath)
            as! HeaderReusableView
        
        let attributedText = (contents?.title ?? "").attributed(by: HeaderReusableView.attributes)
        header.configure(text: attributedText)
        return header
    }
}


// MARK: - OffersCollectionViewDelegate

extension MainViewContoller: UICollectionViewDelegate {

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
    
    func collectionView(_ collectionView: UICollectionView,
                        didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        cell.contentView.backgroundColor = cell.contentView.backgroundColor?
            .withBrightnessAdjustedTo(constant: -0.04)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1) {
            cell.contentView.backgroundColor = cell.contentView.backgroundColor?
                .withBrightnessAdjustedTo(constant: 0.04)
        }
    }
}

// MARK: - OffersCollectionViewDelegateFlowLayout

extension MainViewContoller: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let rect = CGSize(width: MainView.cellWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = NSString(string: contents?.title ?? "")
        let size = text.boundingRect(with: rect, options: [.usesLineFragmentOrigin],
            attributes: HeaderReusableView.attributes, context: nil)
        return CGSize(width: size.width, height: size.height + 15)
    }
}
