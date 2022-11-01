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
    
    init(delegate: APIControllerDelegate) { self.delegate = delegate }
    
    func getGeneralData() {
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data!)
                self.delegate.getContents(contents: response.contents)
                semaphore.signal()
            } catch { return }
        }.resume()
        
        semaphore.wait()
    }
    
    func loadImage(from urlStr: String, to cell: OfferCollectionViewCell) {
        guard let url = URL(string: urlStr) else { return }
        DispatchQueue.global().async { [weak cell] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell?.offerIcon.image = image
                    }
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Cannot load image",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                DispatchQueue.main.async {
                    self.delegate.showError(alert: alert)
                }
            }
        }
    }
}
