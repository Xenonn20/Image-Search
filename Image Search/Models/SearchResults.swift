//
//  SearchResults.swift
//  Image Search
//
//  Created by Кирилл Медведев on 18/09/2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashImage]
}

struct UnsplashImage: Decodable {
    let width: Int
    let height: Int
    let urls: [URLKing.RawValue: String]
}

enum URLKing: String {
    case raw
    case full
    case regular
    case small
    case thumb
}
