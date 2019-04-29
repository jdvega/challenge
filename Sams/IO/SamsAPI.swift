//
//  SamsAPI.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import Foundation

public class SamsAPI {
    
    private struct Constants {
        static let baseURL: String = "https://mobile-tha-server.firebaseapp.com/"
    }
    
    private let session = URLSession(configuration: .default)
    private var activeTasks = [URL: URLSessionDataTask]()
    
    public class func urlWithRelativePath(string: String) -> URL? {
        let absoluteURLString = self.absoluteURLStringWithRelativePath(string: string)
        return URL(string: absoluteURLString)
    }
    
    public func requestWithURL(_ url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if activeTasks[url] != nil {
            return
        }
        
        let completionHandler: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            self.activeTasks[url] = nil
            completion(data, response, error)
        }
        
        let task = session.dataTask(with: url, completionHandler: completionHandler)
        activeTasks[url] = task
        task.resume()
    }
    
    public func cancelTaskForURL(url: URL) {
        if let task = activeTasks[url] {
            task.cancel()
        }
    }
    
    public func cancelAllTasks() {
        activeTasks.forEach { _, task in
            task.cancel()
        }
    }
    
    private class func absoluteURLStringWithRelativePath(string: String) -> String {
        return Constants.baseURL + string
    }
}
