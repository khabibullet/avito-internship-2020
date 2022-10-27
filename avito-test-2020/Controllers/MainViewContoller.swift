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

final class MainViewContoller: UIViewController, APIControllerDelegate {
    var contents: Contents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIController(delegate: self).getGeneralData()
        view = MainView(frame: UIScreen.main.bounds)
        configureNavigationBar()
    }
    
    func getContents(contents: Contents) {
        self.contents = contents
    }
    
    func configureNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        addButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = addButton
    }
}
