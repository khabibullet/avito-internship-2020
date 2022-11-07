//
//  APISimulator.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit


struct Response: Codable {
    let status: String
    let contents: Contents
    
    enum CodingKeys: String, CodingKey {
        case status
        case contents = "result"
    }
}

class APIController {
    let delegate: APIControllerDelegate
    let urlString = "https://raw.githubusercontent.com/avito-tech/internship/main/result.json"
    
    init(delegate: APIControllerDelegate) {
        self.delegate = delegate
    }
    
    var semaph = DispatchSemaphore(value: 0)
    
    func getGeneralData() {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            guard error == nil else { fatalError("URL session error") }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data!)
                self.delegate.setContents(contents: response.contents)
                semaph.signal()
            } catch { fatalError("Cannot decode JSON") }
        }.resume()
        semaph.wait()
    }
    
    func loadIconImages(of offers: [Offer]?) {
        guard let offers = offers else { return }
        
        let group = DispatchGroup()
        for (index, offer) in offers.enumerated() {
            group.enter()
            DispatchQueue.global().async() {
                self.loadImage(from: offer.icon.url, by: index)
                group.leave()
            }
        }
        group.wait()
    }
    
    func loadImage(from url: String, by index: Int) {
        guard let url = URL(string: url) else { return }
        if let data = try? Data(contentsOf: url) {
            self.delegate.setImageData(data: data, index: index)
        } else {
            presentAlertWithMessage(message: "Cannot load image")
        }
    }
    
    func presentAlertWithMessage(message: String) {
        let alert = UIAlertController(
            title: "Error", message: message,
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            self.delegate.presentAlert(alert: alert)
        }
    }
}
