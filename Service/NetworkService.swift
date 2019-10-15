//
//  NetworkService.swift
//  PhotoFill
//
//  Created by Vitaly on 26/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation


class NetworkService {
    
    func request(serachText: String, completion: @escaping (Data?, Error?) -> Void) {
        let params = self.preparePharametrs(searchText: serachText)
        let url = self.url(pharams: params)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeaders() -> [String : String] {
        var headers = [String : String]()
        headers["Authorization"] = "Client-ID 91701ff12cb4d3eed75bab7265f13316973087e82d9d5fe03b0b4240695dcc6f"
        return headers
    }
    
    private func preparePharametrs(searchText: String) -> [String : String] {
        var pharams = [String : String]()
        pharams["query"] = searchText
        pharams["page"] = String(1)
        pharams["per_page"] = String(30)
        return pharams
    }
    
    private func url(pharams: [String : String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = pharams.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
}
