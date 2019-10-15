//
//  SearchResults.swift
//  PhotoFill
//
//  Created by Vitaly on 26/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [UrlKing.RawValue: String]
    
    
    
    enum UrlKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
