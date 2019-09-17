//
//  NetworkDataFetcher.swift
//  Image Search
//
//  Created by Кирилл Медведев on 18/09/2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import Foundation

class NetworkDataFetcher {
    
    let networkService = NetworkService()
    
    func fetchImages(searchTerm: String, completoin: @escaping (SearchResults?) -> Void) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                completoin(nil)
            }
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completoin(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print(jsonError)
            return nil
        }
        
    }
}
