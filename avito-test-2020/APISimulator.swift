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
}

class APISimulator {
    var delegate: APISimulatorDelegate?
    let urlString = "https://raw.githubusercontent.com/avito-tech/internship/main/result.json"
    
    init(delegate: APISimulatorDelegate) { self.delegate = delegate }
    
    func getGeneralData() {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                self.delegate?.alertError(alertMessage: "Cannot acces to \(url)")
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data!)
                self.delegate?.getContents(contents: response.contents)
            } catch { self.delegate?.alertError(alertMessage: "Cannot parse JSON") }
        }
    }
    
//    func getIconForCell(cell: OfferCollectionViewCell) {
//
//    }
}
