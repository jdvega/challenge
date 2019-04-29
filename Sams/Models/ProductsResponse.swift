//
//  ProductsResponse.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

public struct ProductsResponse: Decodable {
    public let totalProducts: Int
    public let pageNumber: Int
    public let pageSize: Int
    public let statusCode: Int
    public var products = [Product]()
    
    //MARK: Decodable Conformance
    enum CodingKeys: String, CodingKey {
        case totalProducts
        case pageNumber
        case pageSize
        case statusCode
    }
}
