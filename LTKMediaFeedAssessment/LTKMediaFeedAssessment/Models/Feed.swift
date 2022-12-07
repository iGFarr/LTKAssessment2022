//
//  Feed.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import Foundation

// MARK: - Feed
struct Feed: Codable {
    let ltks: [Ltk]
    let profiles: [Profile]
    let meta: Meta
    let products: [Product]
    let mediaObjects: [MediaObject]

    enum CodingKeys: String, CodingKey {
        case ltks, profiles, meta, products
        case mediaObjects = "media_objects"
    }
}

// MARK: - Ltk
struct Ltk: Codable {
    let heroImage: String
    let heroImageWidth, heroImageHeight: Int
    let id, profileID, profileUserID: String
    let videoMediaID: String?
    let status: Status
    let caption: String
    let shareURL: String
    let dateCreated, dateUpdated: String
    let dateScheduled: JSONNull?
    let datePublished: String
    let productIDS: [String]
    let hash: String

    enum CodingKeys: String, CodingKey {
        case heroImage = "hero_image"
        case heroImageWidth = "hero_image_width"
        case heroImageHeight = "hero_image_height"
        case id
        case profileID = "profile_id"
        case profileUserID = "profile_user_id"
        case videoMediaID = "video_media_id"
        case status, caption
        case shareURL = "share_url"
        case dateCreated = "date_created"
        case dateUpdated = "date_updated"
        case dateScheduled = "date_scheduled"
        case datePublished = "date_published"
        case productIDS = "product_ids"
        case hash
    }
}

enum Status: String, Codable {
    case published = "PUBLISHED"
}

// MARK: - MediaObject
struct MediaObject: Codable {
    let id: String
    let type: TypeEnum
    let state: State
    let createdAt, updatedAt: String
    let mediaCDNURL: String
    let brandedMediaCDNURL, passthroughMediaCDNURL: String?
    let typeProperties: TypeProperties
    let thumbnailIDS: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, type, state
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mediaCDNURL = "media_cdn_url"
        case brandedMediaCDNURL = "branded_media_cdn_url"
        case passthroughMediaCDNURL = "passthrough_media_cdn_url"
        case typeProperties = "type_properties"
        case thumbnailIDS = "thumbnail_ids"
    }
}

enum State: String, Codable {
    case validatePass = "validate-pass"
}

enum TypeEnum: String, Codable {
    case picture = "picture"
    case video = "video"
}

// MARK: - TypeProperties
struct TypeProperties: Codable {
    let mimeType: MIMEType
    let width, height: Int
    let hasAudioChannel: Bool?

    enum CodingKeys: String, CodingKey {
        case mimeType = "mime_type"
        case width, height
        case hasAudioChannel = "has_audio_channel"
    }
}

enum MIMEType: String, Codable {
    case empty = ""
    case imageJPEG = "image/jpeg"
}

// MARK: - Meta
struct Meta: Codable {
    let lastID: String
    let numResults, totalResults, limit: Int
    let seed: String
    let nextURL: String

    enum CodingKeys: String, CodingKey {
        case lastID = "last_id"
        case numResults = "num_results"
        case totalResults = "total_results"
        case limit, seed
        case nextURL = "next_url"
    }
}

// MARK: - Product
struct Product: Codable {
    let id, ltkID: String
    let hyperlink, imageURL: String
    let links: Links
    let matching: Matching
    let productDetailsID, retailerID, retailerDisplayName: String

    enum CodingKeys: String, CodingKey {
        case id
        case ltkID = "ltk_id"
        case hyperlink
        case imageURL = "image_url"
        case links, matching
        case productDetailsID = "product_details_id"
        case retailerID = "retailer_id"
        case retailerDisplayName = "retailer_display_name"
    }
}

// MARK: - Links
struct Links: Codable {
    let androidConsumerApp, androidConsumerAppSs, iosConsumerApp, iosConsumerAppSs: String
    let ltkEmail, ltkWeb, ltkWidget, tailoredEmail: String

    enum CodingKeys: String, CodingKey {
        case androidConsumerApp = "ANDROID_CONSUMER_APP"
        case androidConsumerAppSs = "ANDROID_CONSUMER_APP_SS"
        case iosConsumerApp = "IOS_CONSUMER_APP"
        case iosConsumerAppSs = "IOS_CONSUMER_APP_SS"
        case ltkEmail = "LTK_EMAIL"
        case ltkWeb = "LTK_WEB"
        case ltkWidget = "LTK_WIDGET"
        case tailoredEmail = "TAILORED_EMAIL"
    }
}

enum Matching: String, Codable {
    case exact = "EXACT"
    case similar = "SIMILAR"
}

// MARK: - Profile
struct Profile: Codable {
    let id: String
    let avatarURL: String
    let avatarUploadURL: JSONNull?
    let displayName, fullName, instagramName, blogName: String
    let blogURL: String
    let bgImageURL: String?
    let bgUploadURL: JSONNull?
    let bio: String
    let rsAccountID: Int
    let searchable: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case avatarUploadURL = "avatar_upload_url"
        case displayName = "display_name"
        case fullName = "full_name"
        case instagramName = "instagram_name"
        case blogName = "blog_name"
        case blogURL = "blog_url"
        case bgImageURL = "bg_image_url"
        case bgUploadURL = "bg_upload_url"
        case bio
        case rsAccountID = "rs_account_id"
        case searchable
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
