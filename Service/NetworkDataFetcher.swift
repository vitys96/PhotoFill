//
//  NetworkDataFetcher.swift
//  PhotoFill
//
//  Created by Vitaly on 26/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation


class NetworkDataFetcher {
    
    var networkService = NetworkService()
    
    func fetchImages(searchText: String, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(serachText: searchText) { (data, error) in
            if let error = error {
                print ("Error received requesting data \(error.localizedDescription)")
                completion(nil)
            }
            let decoded = self.decodeJson(type: SearchResults.self, from: data)
            completion(decoded)
        }
    }
    
    func decodeJson<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print ("FAILED TO DECODE JSON \(jsonError)")
            return nil
        }
    }
}
