//
//  LTKConstants.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

struct LTKConstants {
    static let pageSize: Int = 3
    struct Caching {
        static let cacheDataSizeLimit = 1024 * 1024 * 15
        static let cacheObjectLimit = 150
        static let defaultImageCompression: CGFloat = 0.15
    }
    struct CellIdentifiers {
        static let heroImage = "ltkImageCell"
        static let collectionItem = "LTKCVItem"
    }
    struct ImageNames {
        static let ltkLogo = "ltklogo"
    }
    struct UI {
        static func collectionViewItemCornerRadiusForDimensionSize(_ size: CGFloat = collectionViewItemDimension) -> CGFloat { size * 0.15 }
        static let collectionViewItemDimension: CGFloat = 100
        static let containerSpacer: CGFloat = 100
        static let defaultInset: CGFloat = 8
        static let doubleInset: CGFloat = 16
        static let heroImageHeightRatioAvgEstimate: CGFloat = 1.25
        static let heroImageCornerRadiusForTable: CGFloat = 30
        static let italicizeFontNSKey: CGFloat = 0.075
        static let navSearchBarCornerRadius: CGFloat = 22
        static let navSearchBarTextSize: CGFloat = 14
        static let navSearchBarWidthRatio: CGFloat = 0.7
        static let navTitleTextSize: CGFloat = 20
        static let profilePicBubbleDimension: CGFloat = 50
        static let slightTranslucency: CGFloat = 0.65
        static let thickBorderWidth: CGFloat = 2
        static let thinBorderWidth: CGFloat = 1
    }
    struct URLS {
        static let rewardStyleLTKS = "https://api-gateway.rewardstyle.com/api/ltk/v2/ltks/?featured=true&limit=\(LTKConstants.pageSize)&page_size=\(LTKConstants.pageSize)"
        static let rewardStyleProfiles = "https://api-gateway.rewardstyle.com/api/ltk/v2/profiles/?profile_id="
        static let rewardStyleProducts = "https://api-gateway.rewardstyle.com/api/ltk/v2/products/?"
    }
}
