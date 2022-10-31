//
//  Movie.swift
//  HannahChen-Lab4-2
//
//  Created by Hannah Chen on 10/12/22.
//

import Foundation

struct Movie: Decodable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String?
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}
