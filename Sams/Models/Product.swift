//
//  Product.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

public struct Product: Decodable {
    
    private struct Constants {
        static let productIdKey = "productId"
        static let prodictNameKey = "productName"
        static let shortDescriptionKey = "shortDescription"
        static let longDescriptionKey = "longDescription"
        static let priceKey = "price"
        static let productImageKey = "productImage"
        static let reviewRatingKey = "reviewRating"
        static let reviewCountKey = "reviewCount"
        static let inStockKey = "inStock"
    }
    
    let productId: String
    let productName: String
    let shortDescription: String?
    let longDescription: String
    let priceString: String
    let productImageURLString: String
    let reviewRating: String
    let reviewCount: Int
    let isInStock: Bool
    var adImage: UIImage?
    
    //MARK: Decodable Conformance
    enum CodingKeys: String, CodingKey {
        case productId
        case productName
        case shortDescription
        case longDescription
        case priceString = "price"
        case productImageURLString = "productImage"
        case reviewRating
        case reviewCount
        case isInStock = "inStock"
    }
    
    //MARK: Custom Initializer
    public init?(dict: [String: Any]) {
        let productId = dict[Constants.productIdKey] as? String
        let productName = dict[Constants.prodictNameKey] as? String
        let shortDesc = dict[Constants.shortDescriptionKey] as? String ?? nil
        let longDesc = dict[Constants.longDescriptionKey] as? String
        let price = dict[Constants.priceKey] as? String
        let productImage = dict[Constants.productImageKey] as? String
        let reviewRating = dict[Constants.reviewRatingKey] as? NSNumber
        let reviewCount = dict[Constants.reviewCountKey] as? Int
        let inStock = dict[Constants.inStockKey] as? Bool ?? false
        
        
        if let longDesc = longDesc?.simplifiedFormat,
            let productId = productId,
            let productName = productName,
            let price = price,
            let productImage = productImage,
            let reviewRating = reviewRating,
            let reviewCount = reviewCount{
            
            self.productId = productId
            self.productName = productName.sansEscape
            self.shortDescription = shortDesc?.simplifiedFormat
            self.longDescription = longDesc
            self.priceString = price
            self.productImageURLString = productImage
            self.reviewRating = reviewRating.stringValue
            self.reviewCount = reviewCount
            self.isInStock = inStock
        } else {
            return nil
        }
    }
}

//MARK: Ad Cell Extension
extension Product {
    private struct AdConstants {
        static let adCellKey: String = "advertisement_cell"
        
        static let adImage0 = "advertisement_0"
        static let adText0 = "Zero Percent Financing On All 4K Televisions with Approved Credit."
        static let adSubTextA0 = "10.9% APR"
        static let adSubTextB0 = "No Annual Fee!"
        
        static let adImage1 = "advertisement_1"
        static let adText1 = "Appy for Walmart Visa Card and get 10 Percent Off Today's Purchase."
        static let adSubTextA1 = "6.9% APR"
        static let adSubTextB1 = "0% for 90 Days"
    }
    
    //MARK: Ad Info Container
    private struct AdInfo {
        let imageName: String
        let text: String
        let subText1: String
        let subText2: String
        
        var image: UIImage? {
            if let image = UIImage(named: self.imageName) {
                return image
            } else {
                return nil
            }
        }
    }
    
    //MARK: Custom Initializer with Ad Info
    private init(adInfo: AdInfo) {
        self.productId = AdConstants.adCellKey
        self.productName = String()
        self.shortDescription = String()
        self.longDescription = adInfo.text
        self.priceString = adInfo.subText1
        self.productImageURLString = String()
        self.reviewRating = adInfo.subText2
        self.reviewCount = 0
        self.isInStock = false
        self.adImage = adInfo.image
    }
    
    //MARK: Randomized Ad Provider
    public static func adCellProduct() -> Product {
        let adInfo0 = AdInfo(imageName: AdConstants.adImage0, text: AdConstants.adText0, subText1: AdConstants.adSubTextA0, subText2: AdConstants.adSubTextB0)
        let adInfo1 = AdInfo(imageName: AdConstants.adImage1, text: AdConstants.adText1, subText1: AdConstants.adSubTextA1, subText2: AdConstants.adSubTextB1)
        let adContent: [AdInfo] = [adInfo0, adInfo1]
        return Product(adInfo: adContent.randomElement()!)
    }
    
    public var isAdProduct: Bool {
        return self.productId == AdConstants.adCellKey
    }
}
