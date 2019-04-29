//
//  ProductRepresentable.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/27/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

//MARK: Product Text Formatter
public protocol ProductRepresentable {
    var product: Product { get }
    var productName: String { get }
    var ratingAndReview: String { get }
    var inStockString: String { get }
    var priceString: String { get }
    var descriptionText: String { get }
    var imageURL: URL? { get }
    func callCustomerService()
}

extension ProductRepresentable {
    public var productName: String {
        return product.productName
    }
    
    public var ratingAndReview: String {
        let countString = product.reviewCount == 0 ? "No" : String(product.reviewCount)
        var reviewString = countString + " review"
        if product.reviewCount != 1 {
            reviewString.append("s")
        }
        return product.reviewRating.maxLength(3) + "★ - " + reviewString
    }
    
    public var inStockString: String {
        return isInStock ? "In Stock!" : "On Order"
    }
    
    public var priceString: String {
        return product.priceString
    }
    
    public var descriptionText: String {
        return product.shortDescription ?? "Visit manufacturer's website for product details."
    }
    
    private var isInStock: Bool {
        return product.isInStock
    }
    
    public var imageURL: URL? {
        let url = SamsAPI.urlWithRelativePath(string: product.productImageURLString)
        return url
    }
    public func callCustomerService() {
        guard let number = URL(string: "tel://18009666546") else {
            return
        }
        UIApplication.shared.open(number)
    }
}
