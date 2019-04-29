//
//  AdRepresentable.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/29/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

//MARK: Ad Text Formatter
protocol AdRepresentable: ProductRepresentable {
    var isAdCell: Bool { get }
    var adImage: UIImage? { get }
    var adDescriptionText: String { get }
    var adPriceLabelText: String { get }
    var adRatingLabelText: String { get }
}

extension AdRepresentable {
    public var isAdCell: Bool {
        return self.product.isAdProduct
    }
    
    public var adImage: UIImage? {
        return self.product.adImage
    }
    
    public var adDescriptionText: String {
        return self.product.longDescription
    }
    
    public var adPriceLabelText: String {
        return self.product.priceString
    }
    
    public var adRatingLabelText: String {
        return self.product.reviewRating
    }
}
