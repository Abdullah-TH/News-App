//
//  API.swift
//  News App
//
//  Created by Abdullah Althobetey on 21/04/2021.
//

import Foundation

enum APIError: LocalizedError {
    case statusCode(Int)
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .statusCode(let code):
            return "Error with status code: \(code)"
        case .emptyData:
            return "No data found"
        }
    }
}

class API {
    
    class func loadNews(completion: @escaping (Result<[News], Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: "https://www.abdullahth.com/api/news.json")!) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                DispatchQueue.main.async {
                    completion(.failure(APIError.statusCode(statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.emptyData))
                }
                return
            }
            
            do {
                let newsResponse = try JSONDecoder().decode(NewsRootResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(newsResponse.articles))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
