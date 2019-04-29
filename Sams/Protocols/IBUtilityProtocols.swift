//
//  IBUtilityProtocols.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

//MARK: IB Utility Protocols
protocol SelfDescribable {
    static var typeString: String { get }
}

protocol ReuseIdentifiable: SelfDescribable {
    static var reuseIdentifer: String { get }
}

protocol StoryboardIdentifiable: SelfDescribable {
    static var storyboardIdentifer: String { get }
    static var storyboardName: String { get }
    static var storyboard: UIStoryboard?  { get }
}

protocol NibNamable: SelfDescribable {
    static var nibName: String { get }
    static var nib: UINib? { get }
}

protocol URLImageLoadable {
    var task: URLSessionDataTask? { get set }
    func downloadImage(url: URL, completion: (()->Void)?)
    func cancelDownload()
}
