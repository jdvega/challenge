//
//  PagedProductDataSource.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/27/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

public class PagedProductDataSource {
    public let listDataSource: ProductListDataSource
    private var initialIndexPath: IndexPath?
    private var currentIndexPath: IndexPath
    
    init(listDataSource: ProductListDataSource, initial indexPath: IndexPath) {
        self.listDataSource = listDataSource
        self.initialIndexPath = indexPath
        self.currentIndexPath = indexPath
    }
    
    public var initialViewModel: ProductDetailPageViewModel? {
        if let indexPath = self.initialIndexPath {
            let initialViewModel = productDetailViewModel(for: indexPath)
            self.initialIndexPath = nil
            return initialViewModel
        } else {
            return nil
        }
    }
    
    public func nextViewModel(from indexPath: IndexPath) -> ProductDetailPageViewModel? {
        if let targetViewModel = self.listDataSource.viewModelForIndexAfter(indexPath: indexPath) {
            return ProductDetailPageViewModel(product: targetViewModel.product, indexPath: targetViewModel.indexPath)
        } else {
            return nil
        }
    }
    
    public func prevViewModel(from indexPath: IndexPath) -> ProductDetailPageViewModel? {
        if let targetViewModel = self.listDataSource.viewModelForIndexBefore(indexPath: indexPath) {
            return ProductDetailPageViewModel(product: targetViewModel.product, indexPath: targetViewModel.indexPath)
        } else {
            return nil
        }
    }
    
    private func productDetailViewModel(for indexPath: IndexPath) -> ProductDetailPageViewModel {
        let viewModel = self.listDataSource.viewModelFor(indexPath: indexPath)
        return ProductDetailPageViewModel(product: viewModel.product, indexPath: indexPath)
    }
}
