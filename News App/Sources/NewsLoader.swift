//
//  NewsLoader.swift
//  News App
//
//  Created by Abdullah Althobetey on 24/04/2021.
//

import Foundation

protocol NewsLoader {
    func fetch(completion: @escaping (Result<[News], Error>) -> Void)
}
