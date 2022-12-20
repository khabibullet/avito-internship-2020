//
//  APISimulator.swift
//  avito-test-2020
//
//  Created by Irek Khabibullin on 10/26/22.
//

import UIKit

protocol DataFetchable {
    func fetchDataFromUrl<T: Decodable>(
        urlString: String,
        completion: @escaping (_ contents: T?, _ error: String) -> Void
    )
}

class NetworkService: DataFetchable {
    private init() { }
    static let service = NetworkService()

    func fetchDataFromUrl<T: Decodable>(
        urlString: String,
        completion: @escaping (_ data: T?, _ error: String) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(nil, "Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            do {
                if let data = data, T.self == Data.self {
                    completion(data as? T, "")
                } else {
                    let data = try JSONDecoder().decode(T.self, from: data!)
                    completion(data, "")
                }
            } catch {
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }
}
