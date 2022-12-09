//
//  LTKConstants.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

struct LTKConstants {
    /// MARK: - slightly confused by the units here. thought 1024 * 1024 * 50 would be 50mb, but then the app's memory footprint goes as high
    /// as 1.07GB. However, if I decrease to * 20 the memory footprint doesn't go past 400mb usually. The ratio makes sense at least.
    static let cacheLimitTwentyMb = 1024 * 1024 * 20
    static let cacheObjectLimit = 50
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
        static let thickBorderWidth: CGFloat = 2
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
