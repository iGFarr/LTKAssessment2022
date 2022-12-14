//
//  LTKConstants.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

struct LTKConstants {
    struct Caching {
        static let cacheDataSizeLimit = 1024 * 1024 * 15
        static let cacheObjectLimit = 100
        static let defaultImageCompression: CGFloat = 0.4
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
        static let collectionViewItemDimension = CGFloat(100).scaled
        static let containerSpacer = CGFloat(105).scaled
        static let defaultInset = CGFloat(8).scaled
        static let doubleInset = CGFloat(16).scaled
        static let halfInset = CGFloat(4).scaled
        static let heroImageButtonsSize = CGFloat(45).scaled
        static let heroImageHeightRatioAvgEstimate: CGFloat = 1.25
        static let heroImageCornerRadiusForTable = CGFloat(30).scaled
        static let homePageHeaderHeight = CGFloat(30).scaled
        static let homePageHeaderTextSize = CGFloat(18).scaled
        static let imageWidthQueryParamValue: Int = 800 // for memory footprint reduction
        static let italicizeFontNSKey: CGFloat = 0.075
        static let navSearchBarCornerRadius = CGFloat(17).scaled
        static let navSearchBarHeight = CGFloat(35).scaled
        static let navSearchBarTextSize = CGFloat(14).scaled
        static let navSearchBarWidthRatio: CGFloat = 0.7
        static let navTitleTextSize = CGFloat(20).scaled
        static let profileNameLabelHeight = CGFloat(35).scaled
        static let profilePicBubbleDimension = CGFloat(50).scaled
        static let slightTranslucency: CGFloat = 0.85
        static let substantiallyTranslucent: CGFloat = 0.4
        static let thickBorderWidth: CGFloat = 2
        static let thinBorderWidth: CGFloat = 1
        static var isIpad: Bool {
            UIDevice.current.userInterfaceIdiom == .pad
        }
        static var isVerySmallScreen: Bool {
            UIScreen.main.bounds.width < 350 && UIScreen.main.bounds.height < 600
        }
        static var scaleMultiplier: CGFloat {
            if isIpad {
                return 1.5
            }
            if isVerySmallScreen {
                return 0.75
            }
            return 1.0
        }
    }
    struct URLS {
        // I had been obfuscating these URLs in my repo, but I think I'll just privatize it after the demo.
        static let pageSize: Int = 3
        static let rewardStyleLTKS = "https://api-gateway.rewardstyle.com/api/ltk/v2/ltks/?featured=true&limit=20&page_size=\(pageSize)"
        static let rewardStyleProfiles = "https://api-gateway.rewardstyle.com/api/ltk/v2/profiles/?profile_id="
        static let rewardStyleProducts = "https://api-gateway.rewardstyle.com/api/ltk/v2/products/?"
    }
}
