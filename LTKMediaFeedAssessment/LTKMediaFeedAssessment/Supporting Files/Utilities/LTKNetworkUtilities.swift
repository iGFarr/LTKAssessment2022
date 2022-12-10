//
//  LTKUtilities.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import Foundation

struct LTKNetworkUtilites {
    static func getFeed(completion: @escaping (Result<Feed, Error>) -> Void) {
        guard let url = URL(string: LTKConstants.URLS.rewardStyleLTKS) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error.localizedDescription as! Error))
                return
            }
            guard let data = data else { return }
            if let feed = self.decodeData(data: data, type: Feed.self) {
                completion(.success(feed))
                print("LTKS Count: \(feed.ltks.count)")
            }
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
