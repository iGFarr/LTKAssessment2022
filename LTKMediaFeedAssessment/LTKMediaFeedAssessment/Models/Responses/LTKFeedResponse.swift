//
//  Feed.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import Foundation

// MARK: - Feed
struct LTKFeedResponse: Codable {
    let ltks: [Ltk]
    let profiles: [Profile]
    let products: [Product]
    enum CodingKeys: String, CodingKey {
        case ltks, profiles, products
    }
}

// MARK: - Ltk
struct Ltk: Codable {
    let heroImage: String
    let heroImageWidth, heroImageHeight: Int
    let id, profileID, profileUserID: String
    let caption: String
    let shareURL: String
    let productIDS: [String]
    let publishDate: String

    enum CodingKeys: String, CodingKey {
        case heroImage = "hero_image"
        case heroImageWidth = "hero_image_width"
        case heroImageHeight = "hero_image_height"
        case id
        case profileID = "profile_id"
        case profileUserID = "profile_user_id"
        case caption
        case shareURL = "share_url"
        case productIDS = "product_ids"
        case publishDate = "date_published"
    }
}

// MARK: - Product
struct Product: Codable, Hashable {
    let id, ltkID: String
    let hyperlink, imageURL: String
    let productDetailsID, retailerID, retailerDisplayName: String

    enum CodingKeys: String, CodingKey {
        case id
        case ltkID = "ltk_id"
        case hyperlink
        case imageURL = "image_url"
        case productDetailsID = "product_details_id"
        case retailerID = "retailer_id"
        case retailerDisplayName = "retailer_display_name"
    }
}


// MARK: - Profile
struct Profile: Codable, Hashable {
    let id: String
    let avatarURL: String
    let displayName: String
    let rsAccountID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case displayName = "display_name"
        case rsAccountID = "rs_account_id"
    }
}
