//
//  DynamicImageView.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import Foundation

import UIKit

public class DynamicImageView: UIImageView, URLImageLoadable {
    
    public var task: URLSessionDataTask?
    
    public func downloadImage(url: URL, completion: (()->Void)?) {
        if let image = ImageCache.sharedInstance.object(forKey: url.absoluteString as NSString) {
            self.populateImage(image)
            completion?()
        }
        
        DispatchQueue.global().async {
            self.task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard error == nil, let data = data, let image = UIImage(data: data) else {
                    return
                }
                ImageCache.sharedInstance.setObject(image, forKey: url.absoluteString as NSString)
                self.populateImage(image)
            }
            self.task?.resume()
        }
    }
    
    public func cancelDownload() {
        self.task?.cancel()
        self.task = nil
    }
    
    private func populateImage(_ image: UIImage) {
        DispatchQueue.main.async() {
            self.image = image
        }
    }
}
