//
//  APIResults.swift
//  HannahChen-Lab4-2
//
//  Created by Hannah Chen on 10/12/22.
//

import Foundation

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}
