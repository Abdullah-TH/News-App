//
//  FileNewsLoader.swift
//  News App
//
//  Created by Abdullah Althobetey on 24/04/2021.
//

import Foundation

class FileNewsLoader: NewsLoader {
    
    func fetch(completion: @escaping (Result<[News], Swift.Error>) -> Void) {
        
        guard let path = Bundle.main.path(forResource: "news", ofType: "json") else {
            DispatchQueue.main.async {
                completion(.failure(Error.fileNotFound))
            }
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
            let newsRoot = try JSONDecoder().decode(NewsRootResponse.self, from: data)
            DispatchQueue.main.async {
                completion(.success(newsRoot.articles))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    private enum Error: LocalizedError {
        case fileNotFound
        
        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "File not found"
            }
        }
    }
}
