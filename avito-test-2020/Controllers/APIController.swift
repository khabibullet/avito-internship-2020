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
    let urlString = "https://raw.githubusercontent.com/avito-tech/internship/main/result.json"
    
    private init() { }
    static let service = APIController()
    
    func getGeneralData(destination: MainViewContoller?) {
        let semaph = DispatchSemaphore(value: 0)
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak destination] (data, response, error) in
            guard error == nil else { fatalError("URL session error") }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data!)
                destination?.setContents(contents: response.contents)
                semaph.signal()
            } catch { fatalError("Cannot decode JSON") }
        }.resume()
        semaph.wait()
    }
    
    func loadIconImages(of offers: [Offer]?, to destination: MainViewContoller?) {
        guard let offers = offers else { return }
        
        let group = DispatchGroup()
        for (index, offer) in offers.enumerated() {
            group.enter()
            DispatchQueue.global().async() {
                guard let url = URL(string: offer.icon.url) else { return }
                if let data = try? Data(contentsOf: url) {
                    destination?.setImageData(data: data, index: index)
                } else {
                    APIController.service.presentAlertWithMessage(
                        message: "Cannot load image",
                        destination: destination)
                }
                group.leave()
            }
        }
        group.wait()
    }
    
    func presentAlertWithMessage(message: String, destination: MainViewContoller?) {
        let alert = UIAlertController(
            title: "Error", message: message,
            preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            destination?.presentAlert(alert: alert)
        }
    }
}
