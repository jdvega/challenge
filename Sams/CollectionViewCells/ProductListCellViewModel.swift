//
//  ProductListCellViewModel.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

public class ProductListCellViewModel: ProductRepresentable, AdRepresentable {
    public var product: Product
    
    public init(product: Product) {
        self.product = product
    }
}

public class IndexedProductListCellViewModel: ProductListCellViewModel {
    public let indexPath: IndexPath
    
    public init(product: Product, indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(product: product)
    }
}
