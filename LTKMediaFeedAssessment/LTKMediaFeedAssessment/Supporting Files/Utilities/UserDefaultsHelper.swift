//
//  UserDefaultsHelper.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/13/22.
//

import Foundation

class UserDefaultsHelper {
    private static let arrayCap = 300
    private struct DefaultKeys {
        enum Arrays: String {
            case followedCreators = "followedCreators"
            case favoritedLtks = "favoritedLtks"
        }
    }
    
    // Usage: retrieve and set from these instance properties. *It's that easy :)
    // *With the exception of set conversions and back to array. Will abstract that extraneous work out later if I still feel like working on this project.
    var followedCreators: [String] = getDefaultsSet(key: .followedCreators) {
        willSet {
            Self.setDefaultsSet(key: .followedCreators, value: newValue)
        }
    }
    var favoritedLtks: [String] = getDefaultsSet(key: .favoritedLtks) {
        willSet {
            Self.setDefaultsSet(key: .favoritedLtks, value: newValue)
        }
    }
    
    static private func setDefaultsSet<T: Hashable>(key: UserDefaultsHelper.DefaultKeys.Arrays, value: [T]) {
        var copy = value
        if copy.count > arrayCap {
            copy.removeFirst()
        }
        let removeDuplicates = Set<T>(copy)
        let storageArray = Array(removeDuplicates)
        UserDefaults.standard.set(storageArray, forKey: key.rawValue)
    }
    
    static private func getDefaultsSet<T: Hashable>(key: UserDefaultsHelper.DefaultKeys.Arrays) -> [T] {
        return UserDefaults.standard.value(forKey: key.rawValue) as? [T] ?? [T]()
    }
}
