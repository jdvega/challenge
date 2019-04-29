//
//  ProductListCollectionViewSection.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import Foundation

public class ProductListCollectionViewSection {
    
    public let cellViewModels: [ProductListCellViewModel]
    public let pageNumber: Int
    
    public init(cellViewModels: [ProductListCellViewModel], pageNumber: Int) {
        self.cellViewModels = cellViewModels
        self.pageNumber = pageNumber
    }
}
