//
//  ImageCache.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

public class ImageCache {
    public class var sharedInstance: NSCache<NSString, UIImage> {
        struct Static {
            static let shared: NSCache = NSCache<NSString, UIImage>()
        }
        return Static.shared
    }
}
