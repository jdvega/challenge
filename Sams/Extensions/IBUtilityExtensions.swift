//
//  IBUtilityExtensions.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

extension SelfDescribable {
    static var typeString: String {
        return String(describing: self)
    }
}

extension ReuseIdentifiable {
    static var reuseIdentifer: String {
        return typeString
    }
}

extension StoryboardIdentifiable {
    static var storyboardIdentifer: String {
        return typeString
    }
    
    static var storyboard: UIStoryboard? {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
    
    static var viewControllerFromStoryboard: UIViewController? {
        return storyboard?.instantiateViewController(withIdentifier: storyboardIdentifer)
    }
}

extension NibNamable {
    static var nibName: String {
        return typeString
    }
    
    static var nib: UINib? {
        return UINib(nibName: nibName, bundle: nil)
    }
}
