//
//  ProductDetailPageViewModel.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/26/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

public struct ProductDetailPageViewModel: ProductRepresentable, AdRepresentable {
    public var product: Product
    public var indexPath: IndexPath
    
    public init(product: Product, indexPath: IndexPath) {
        self.product = product
        self.indexPath = indexPath
    }
}
