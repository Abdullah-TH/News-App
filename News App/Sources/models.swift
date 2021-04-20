//
//  models.swift
//  News App
//
//  Created by Abdullah Althobetey on 21/04/2021.
//

import Foundation

struct NewsRootResponse: Codable {
    let articles: [News]
}

struct News: Codable {
    let title: String
    let description: String
}
