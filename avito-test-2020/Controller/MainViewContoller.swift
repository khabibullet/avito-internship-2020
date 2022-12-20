//
//  ViewController.swift
//  avito-test-2020
//
//  Created by Irek Khabibullin on 10/26/22.
//

import UIKit

final class MainViewContoller: UIViewController {

    private let screenContents: OffersScreenContents
    private var mainView: MainView {
        return self.view as? MainView ?? MainView()
    }

    init(networkManager: DataFetchable) {
        screenContents = OffersScreenContents(networkManager: networkManager)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var loadStatus: LoadStatus = .success
        screenContents.setInitialState(viewController: self) { status in
            loadStatus = status
        }
        if loadStatus == .failure { return }

        mainView.offersCollectionView.delegate = self
        mainView.offersCollectionView.dataSource = self
        mainView.offersCollectionView.delaysContentTouches = false
        mainView.offersCollectionView.register(
            OfferCollectionViewCell.self,
            forCellWithReuseIdentifier: OfferCollectionViewCell.identifier
        )
        mainView.offersCollectionView.register(
            HeaderReusableView.self,
            forSupplementaryViewOfKind:
                UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier
        )

        mainView.selectionButton.addTarget(
            self, action: #selector(selectionButtonTapped), for: .touchUpInside
        )
        mainView.configureSelectionButton(
            appearance: .light, title: screenContents.getActionTitle()
        )

        if let bar = navigationController?.navigationBar {
            mainView.configureNavigationBar(bar: bar)
        }
    }

    @objc private func selectionButtonTapped() {
        var message = "\nПродолжить без изменений?"
        if let offerId = screenContents.getCurrentSelectedOfferId() {
            message = """
            \nВы выбрали услугу
            \"\(screenContents.getOfferTitle(id: offerId))\"
            """
        }
        presentAlert(title: "Подтвердить?", message: message, completion: nil)
    }
}

// MARK: - AlertDelegate

protocol AlertDelegate: AnyObject {
    func presentAlert(
        title: String,
        message: String,
        completion: ((UIAlertAction) -> Void)?
    )
}

extension MainViewContoller: AlertDelegate {
    public func presentAlert(
        title: String,
        message: String,
        completion: ((UIAlertAction) -> Void)?
    ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertAction.Style.default,
                    handler: completion
                )
            )
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - OffersCollectionViewDataSource

extension MainViewContoller: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return screenContents.countOffers() ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = mainView.offersCollectionView.dequeueReusableCell(
            withReuseIdentifier: OfferCollectionViewCell.identifier,
            for: indexPath
        ) as? OfferCollectionViewCell else { return OfferCollectionViewCell() }

        guard let offer = screenContents.getOffer(id: indexPath.row) else {
            return cell
        }
        cell.configureOfferCell(offer: offer)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier, for: indexPath
        ) as? HeaderReusableView else { return HeaderReusableView() }

        let attributedText = screenContents.getTitle().attributed(
            by: HeaderReusableView.attributes
        )
        header.configure(text: attributedText)
        return header
    }
}

// MARK: - OffersCollectionViewDelegate

extension MainViewContoller: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if screenContents.getCurrentSelectedOfferId() == indexPath.row {
            screenContents.setCurrentSelectedOfferId(id: nil)
            mainView.configureSelectionButton(
                appearance: .light, title: screenContents.getActionTitle()
            )
        } else {
            screenContents.setCurrentSelectedOfferId(id: indexPath.row)
            mainView.configureSelectionButton(
                appearance: .dark, title: screenContents.getActionTitle()
            )
        }
        mainView.offersCollectionView.reloadData()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didHighlightItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        cell.contentView.backgroundColor = cell.contentView.backgroundColor?
            .withBrightnessAdjustedTo(constant: -0.04)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didUnhighlightItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        UIView.animate(withDuration: 0.1) {
            cell.contentView.backgroundColor = cell.contentView.backgroundColor?
                .withBrightnessAdjustedTo(constant: 0.04)
        }
    }
}

// MARK: - OffersCollectionViewDelegateFlowLayout

extension MainViewContoller: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {

        let rect = CGSize(
            width: MainView.cellWidth,
            height: CGFloat.greatestFiniteMagnitude
        )
        let text = NSString(string: screenContents.getTitle())
        let size = text.boundingRect(
            with: rect, options: [.usesLineFragmentOrigin],
            attributes: HeaderReusableView.attributes, context: nil
        )
        return CGSize(width: size.width, height: size.height + 15)
    }
}
