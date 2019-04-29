//
//  ProductsFetcher.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import Foundation

public class ProductsFetcher {
    
    private struct Constants {
        static let productsEndpoint: String = "walmartproducts/"
    }
    
    public let api: SamsAPI
    
    init(api: SamsAPI = SamsAPI()) {
        self.api = api
    }
    
    public func fetchProducts(pageNumber: Int, pageSize: Int = 10, completion: @escaping (ProductsResponse) -> Void) {
        
        let apiCompletionHandler: (Data?, URLResponse?, Error?) -> Void = { data, response, error in
            
            if let data = data, let responseObject  = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) {
                
                guard var dataInDictionary = responseObject as? [String: Any], let productsDictArray = dataInDictionary["products"] as? [[String: Any]] else {
                    return
                }
                
                let productsArray: [Product] = productsDictArray.compactMap { dict -> Product? in
                    return Product(dict: dict)
                }
                
                dataInDictionary["products"] = nil
                
                guard var productsResponse = try? JSONDecoder().decode(ProductsResponse.self, from: data) else {
                    return
                }
                productsResponse.products = productsArray
                completion(productsResponse)
            }
        }
        
        let pagedURL = Constants.productsEndpoint + "\(pageNumber)/\(pageSize)"
        
        if let url = SamsAPI.urlWithRelativePath(string: pagedURL) {
            self.api.requestWithURL(url, completion: apiCompletionHandler)
        }
    }
}
