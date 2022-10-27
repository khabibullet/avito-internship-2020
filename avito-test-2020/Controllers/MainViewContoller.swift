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
    var mainView: MainView?
    var navBarItem = UINavigationItem()
    var contents: Contents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIController(delegate: self).getGeneralData()
        configureNavigationBar()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        mainView = MainView(frame: UIScreen.main.bounds)
        self.view = mainView
    }
    
    func getContents(contents: Contents) {
        self.contents = contents
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let addButton = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        addButton.tintColor = .black
        navigationItem.leftBarButtonItem = addButton
    }
}
