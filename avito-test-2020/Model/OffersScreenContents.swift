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
    
    private let initialUrl = """
    https://raw.githubusercontent.com/\
    khabibullet/avito-test-2020/master/readme/result.json
    """
    
    let networkManager: DataFetchable
    weak var viewController: MainViewContoller?
    
    private var contents: Contents?
    private var currentSelectedOfferId: Int? {
        didSet {
            if let oldValue = oldValue {
                contents?.offers[oldValue].isSelected = false
            }
            if let newValue = currentSelectedOfferId {
                contents?.offers[newValue].isSelected = true
            }
        }
    }
    
    init(networkManager: DataFetchable) {
        self.networkManager = networkManager
        self.currentSelectedOfferId = nil
    }
    
    public func getCurrentSelectedOfferId() -> Int? {
        return currentSelectedOfferId
    }
    
    public func setCurrentSelectedOfferId(id: Int?) {
        self.currentSelectedOfferId = id
    }
 
    public func countOffers() -> Int? {
        return contents?.offers.count
    }
    
    public func getOffer(id: Int) -> Offer? {
        return contents?.offers[id]
    }
    
    public func getTitle() -> String {
        return contents?.title ?? ""
    }
    
    public func getOfferTitle(id: Int) -> String {
        return contents?.offers[id].title ?? ""
    }
    
    public func getActionTitle() -> String {
        if currentSelectedOfferId != nil {
            return contents?.selectedActionTitle ?? ""
        } else {
            return contents?.actionTitle ?? ""
        }
    }
    
    public func setInitialState(
        viewController: MainViewContoller, closure: (LoadStatus) -> ()
    ) {
        self.viewController = viewController
        loadContents()
        guard contents != nil else {
            print("contents appear to be nil")
            closure(.failure)
            return
        }
        loadIcons()
        setCheckmarksUnchecked()
        closure(.success)
    }
    
    public func setCheckmarksUnchecked() {
        guard contents != nil else { return }
        for (index, _) in contents!.offers.enumerated() {
            contents!.offers[index].isSelected = false
        }
    }
    
    private func loadContents() {
        let semaphore = DispatchSemaphore(value: 0)
        networkManager.fetchDataFromUrl(urlString: initialUrl) {
            (data: Response?, error: String)  in
            if let response = data {
                self.contents = response.contents
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
        guard contents?.offers != nil else { return }

        let group = DispatchGroup()
        for (index, _) in contents!.offers.enumerated() {
            group.enter()
            self.networkManager.fetchDataFromUrl(
                urlString: self.contents!.offers[index].icon.url
            ) { (data: Data?, error: String)  in
                self.contents!.offers[index].icon.image = data
                group.leave()
            }
        }
        group.wait()
    }
}
