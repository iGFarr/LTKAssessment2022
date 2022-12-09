//
//  LTKConstants.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

struct LTKConstants {
    static let cacheLimitFiftyMb = 1024 * 1024 * 50
    static let cacheLimitTwentyObjects = 20
    struct CellIdentifiers {
        static let heroImage = "ltkImageCell"
        static let collectionItem = "LTKCVItem"
    }
    struct ImageNames {
        static let ltkLogo = "ltklogo"
    }
    struct UI {
        static func collectionViewItemCornerRadiusForDimensionSize(_ size: CGFloat) -> CGFloat { size * 0.15 }
        static let collectionViewItemDimension: CGFloat = 100
        static let defaultInset: CGFloat = 8
        static let doubleInset: CGFloat = 16
        static let italicizeFontNSKey: CGFloat = 0.075
        static let navSearchBarCornerRadius: CGFloat = 22
        static let navSearchBarTextSize: CGFloat = 14
        static let navSearchBarWidthRatio: CGFloat = 0.7
        static let navTitleTextSize: CGFloat = 20
        static let profilePicBubbleDimension: CGFloat = 50
        static let slightTranslucency: CGFloat = 0.8
        static let thickBorderWitdth: CGFloat = 2
        static let thinBorderWidth: CGFloat = 1
    }
    struct URLS {
        static let rewardStyleLTKS = "https://api-gateway.rewardstyle.com/api/ltk/v2/ltks/?featured=true&limit=20"
    }
    struct Strings {
        static let postsYouLike = "For You: Posts we think you'll like"
        static let searchPlaceholder = "Search fashion, home, & more"
    }
}
