//
//  OffersScreenContents.swift
//  avito-test-2020
//
//  Created by Ирек Хабибуллин on 19.12.2022.
//

import UIKit

public enum LoadStatus {
    case success
    case failure
}

class OffersScreenContents: NSObject {

    let networkManager: DataFetchable
    weak var viewController: MainViewContoller?

    private var offers: Offers = []
    private var headTitle: String = ""
    private var actionTitle: String = ""
    private var selectedActionTitle: String = ""

    private var currentSelectedOfferId: Int? = nil {
        didSet {
            if let oldValue = oldValue {
                offers[oldValue].isSelected = false
            }
            if let newValue = currentSelectedOfferId {
                offers[newValue].isSelected = true
            }
        }
    }

    init(networkManager: DataFetchable) {
        self.networkManager = networkManager

    }

    public func getCurrentSelectedOfferId() -> Int? {
        return currentSelectedOfferId
    }

    public func setCurrentSelectedOfferId(id: Int?) {
        self.currentSelectedOfferId = id
    }

    public func countOffers() -> Int? {
        return offers.count
    }

    public func getOffer(id: Int) -> Offer? {
        return offers[id]
    }

    public func getTitle() -> String {
        return headTitle
    }

    public func getOfferTitle(id: Int) -> String {
        return offers[id].title
    }

    public func getActionTitle() -> String {
        if currentSelectedOfferId != nil {
            return selectedActionTitle
        } else {
            return actionTitle
        }
    }

    public func setInitialState(
        viewController: MainViewContoller, closure: (LoadStatus) -> Void
    ) {
        self.viewController = viewController
        loadContents()
        guard offers.isEmpty != true else {
            closure(.failure)
            return
        }
        loadIcons()
        setCheckmarksUnchecked()
        closure(.success)
    }

    public func setCheckmarksUnchecked() {
        guard offers.isEmpty != true else { return }

        for index in offers.indices {
            offers[index].isSelected = false
        }
    }

    public func getInitialURL() -> String {
        guard let path = Bundle.main.path(
            forResource: "Info", ofType: ".plist"
        ) else { return "" }

        guard let dictionary = NSDictionary(
            contentsOfFile: path
        ) else { return "" }

        guard let initialURL = dictionary.object(forKey: "Initial URL")
            as? String else { return "" }

        return initialURL
    }

    private func loadContents() {
        let initialUrl = getInitialURL()
        let semaphore = DispatchSemaphore(value: 0)
        networkManager.fetchDataFromUrl(
            urlString: initialUrl
        ) { (data: Response?, error: String)  in
            if let response = data {
                self.offers = response.result.list
                self.headTitle = response.result.title
                self.actionTitle = response.result.actionTitle
                self.selectedActionTitle = response.result.selectedActionTitle
            } else {
                self.viewController?.presentAlert(
                    title: "Error", message: error,
                    completion: { _ in fatalError(error) }
                )
            }
            semaphore.signal()
        }
        semaphore.wait()
    }

    private func loadIcons() {
        guard offers.isEmpty != true else { return }

        let group = DispatchGroup()
        for index in offers.indices {
            group.enter()
            self.networkManager.fetchDataFromUrl(
                urlString: self.offers[index].icon.url
            ) { (data: Data?, _: String)  in
                self.offers[index].icon.image = data
                group.leave()
            }
        }
        group.wait()
    }
}
