//
//  ViewController.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit


class OffersCollectionViewContoller: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var navBarItem = UINavigationItem()
    var networkService: APISimulator?
    var contents: Contents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService = APISimulator(delegate: self)
        print("view did load")
        networkService?.getGeneralData()
        configureNavigationBar()
        view.backgroundColor = .white
        collectionView?.register(OfferCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("here:", contents?.title)
        return contents?.offers.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! OfferCollectionViewCell
        
        cell.label?.text = contents?.offers[indexPath.row].title
        
        print(contents?.offers[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize.init(width: view.frame.width, height: 250)
        }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OffersCollectionViewContoller {
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let addButton = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
    }
    
}

protocol APISimulatorDelegate {
    func alertError(alertMessage: String?)
    func getContents(contents: Contents)
}


extension OffersCollectionViewContoller: APISimulatorDelegate {
    func alertError(alertMessage: String?) {
        let alert = UIAlertController(title: "Error", message: alertMessage ?? "error occured",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getContents(contents: Contents) {
        self.contents = contents
    }
}
