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
    var delegate: APIControllerDelegate?
    let urlString = "https://raw.githubusercontent.com/avito-tech/internship/main/result.json"
    
    init(delegate: APIControllerDelegate) { self.delegate = delegate }
    
    func getGeneralData() {
        let semaphore = DispatchSemaphore(value: 0)
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data!)
                self.delegate?.getContents(contents: response.contents)
                semaphore.signal()
            } catch { return }
        }.resume()
        
        semaphore.wait()
    }
}
