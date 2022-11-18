//
//  APISimulator.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit

class APIController {
    private init() { }
    static let service = APIController()
    
    func getGeneralData(destination: MainViewContoller?) {
        let urlString = "https://raw.githubusercontent.com/khabibullet/avito-test-2020/master/readme/result.json"
        
        guard let url = URL(string: urlString) else {
            self.presentAlertWithMessage(message: "Invalid URL", destination: destination)
            return
        }
        
        let semaph = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { [weak destination] (data, response, error) in
            if let error = error {
                self.presentAlertWithMessage(message: error.localizedDescription,
                                        destination: destination)
            } else {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data!)
                        destination?.setContents(contents: response.contents)
                } catch {
                    self.presentAlertWithMessage(message: error.localizedDescription,
                                            destination: destination)
                }
            }
            semaph.signal()
        }.resume()
        semaph.wait()
    }

    func loadIconImages(of offers: [Offer]?, to destination: MainViewContoller?) {
        guard let offers = offers else { return }
        
        let group = DispatchGroup()
        for (index, _) in offers.enumerated() {
            group.enter()
            DispatchQueue.global().async() {
                guard let url = URL(string: offers[index].icon.url) else { return }
                if let data = try? Data(contentsOf: url) {
                    destination?.setImageData(data: data, index: index)
                }
                group.leave()
            }
        }
        group.wait()
    }

    func presentAlertWithMessage(message: String, destination: MainViewContoller?) {
        let alert = UIAlertController(
            title: "Error", message: "Fatal error: \(message)",
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: { _ in fatalError(message) }))
        DispatchQueue.main.async {
            destination?.presentAlert(alert: alert)
        }
    }
}
