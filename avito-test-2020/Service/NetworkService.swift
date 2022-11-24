//
//  APISimulator.swift
//  avito-test-2020
//
//  Created by Irek Khabibullin on 10/26/22.
//

import UIKit

protocol DataFetchable {
    func fetchInitialData(completion: @escaping (_ contents: Contents?,
        _ error: String) -> Void)
    
    func getRawData(iconURL: String, completion: @escaping
        (_ data: Data?) -> Void)
}

class NetworkService: DataFetchable {
    private init() { }
    static let service = NetworkService()
    
    private static let initialURL = """
    https://raw.githubusercontent.com/\
    khabibullet/avito-test-2020/master/readme/result.json
    """
    
    func fetchInitialData(completion: @escaping (_ contents: Contents?,
        _ error: String) -> Void) {
        guard let url = URL(string: NetworkService.initialURL) else {
            completion(nil, "Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data!)
                completion(response.contents, "")
            } catch {
                completion(nil, error.localizedDescription)
            }
        }.resume()
    }
    
    
    func getRawData(iconURL: String, completion: @escaping
        (_ data: Data?) -> Void) {
        guard let url = URL(string: iconURL) else { return }
        if let data = try? Data(contentsOf: url) {
            completion(data)
        }
    }
}
