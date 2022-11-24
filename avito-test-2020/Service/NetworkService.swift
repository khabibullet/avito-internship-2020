//
//  APISimulator.swift
//  avito-test-2020
//
//  Created by Alebelly Nemesis on 10/26/22.
//

import UIKit

protocol DataFetchable {
    func fetchInitialData(completion: @escaping (_ contents: Contents?,
        _ error: String) -> Void)
}

class NetworkService: DataFetchable {
    private init() { }
    static let service = NetworkService()
    
    static let initialURL = """
    https://raw.githubusercontent.com/\
    khabibullet/avito-test-2020/master/readme/result.json
    """
    
    func fetchInitialData(completion: @escaping (_ contents: Contents?,
        _ error: String) -> Void) {
        guard let url = URL(string: NetworkService.initialURL) else {
            print("invalid URL")
            completion(nil, "Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            print(url)
            if let error = error {
                print(1, error.localizedDescription)
                completion(nil, error.localizedDescription)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data!)
                completion(response.contents, "")
            } catch {
                print(2, error.localizedDescription)
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }

//    func loadIconImages(of offers: [Offer]?, to destination: MainViewContoller?) {
//        guard let offers = offers else { return }
//
//        let group = DispatchGroup()
//        for (index, _) in offers.enumerated() {
//            group.enter()
//            DispatchQueue.global().async() {
//                guard let url = URL(string: offers[index].icon.url) else { return }
//                if let data = try? Data(contentsOf: url) {
//                    destination?.setImageData(data: data, index: index)
//                }
//                group.leave()
//            }
//        }
//        group.wait()
//    }
}
