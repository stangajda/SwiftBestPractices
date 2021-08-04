//
//  FDRImageCache.swift
//  FeedReader
//
//  Created by Stan Gajda on 26/07/2021.
//

import UIKit
import SwiftUI

protocol FDRImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct FDRTemporaryImageCache: FDRImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set {
            guard let newValue = newValue else {
                cache.removeObject(forKey: key as NSURL)
                return
            }
            cache.setObject(newValue, forKey: key as NSURL)
        }
    }
}

struct FDRImageCacheKey: EnvironmentKey {
    static let defaultValue: FDRImageCache = FDRTemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: FDRImageCache {
        get { self[FDRImageCacheKey.self] }
        set { self[FDRImageCacheKey.self] = newValue }
    }
}
