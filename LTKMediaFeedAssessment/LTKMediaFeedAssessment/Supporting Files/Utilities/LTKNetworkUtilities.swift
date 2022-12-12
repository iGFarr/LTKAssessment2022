//
//  LTKUtilities.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import Foundation

struct LTKNetworkUtilites {
    static func getFeed(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response , error in
            if let error = error {
                completion(.failure(error.localizedDescription as! Error))
                return
            }
            guard let data = data else { return }
            print("LTKFeedResponse: \(String(describing: response))")
            completion(.success(data))
        }
        task.resume()
    }
    
    static func decodeData<T: Decodable>(data: Data, type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(type.self, from: data)
        } catch {
            print("JSON decode error:", error)
            return nil
        }
    }

}
