//
//  LTKFeedRequest.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/11/22.
//

import Foundation

class LTKFeedRequest {
    
    var page = 0
    var displayName: String?
    func makeRequest(with string: String = LTKConstants.URLS.rewardStyleLTKS, pageZero: Bool = false, completion: @escaping (Result<LTKFeedResponse?, Error>) -> Void) {
        let pageToGet = pageZero ? 0 : self.page
        var urlString = "\(string)&page=\(pageToGet)"
        if let displayName = self.displayName {
            urlString = urlString.replacingOccurrences(of: "featured=true&", with: "")
            urlString += "&display_name=\(displayName)"
        }
        
        LTKNetworkUtilites.getFeed(fromURLString: urlString, completion: { result in
            switch result {
            case .success(let response):
                completion(.success(LTKNetworkUtilites.decodeData(data: response, type: LTKFeedResponse.self)))
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func matchProfile(profileId: String, completion: @escaping (Result<Profile?, Error>) -> Void ) {
        LTKNetworkUtilites.getFeed(fromURLString: "\(LTKConstants.URLS.rewardStyleProfiles)\(profileId)", completion: { result in
            switch result {
            case .success(let response):
                if let profiles = LTKNetworkUtilites.decodeData(data: response, type: [Profile].self) {
                    for profile in profiles {
                        if profile.id == profileId {
                            completion(.success(profile))
                            return
                        }
                    }
                } else {
                    print("Failed to match profile")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
