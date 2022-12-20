//
//  AppDelegate.swift
//  avito-test-2020
//
//  Created by Irek Khabibullin on 10/26/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [
            UIApplication.LaunchOptionsKey: Any
        ]?
    ) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        let networkService = NetworkService.service
        let viewController = MainViewContoller(networkManager: networkService)
        window.rootViewController = UINavigationController(
            rootViewController: viewController
        )
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
