//
//  ProductListViewModel.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/21/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import Foundation
import UIKit

public enum ProductListLayout: Int {
    case grid
    case row
}

public protocol ProductListDataSourceDelegate {
    func dataSource(_ dataSource: ProductListDataSource, requestsPage pageNumber: Int)
}

public class ProductListViewModel {
    
    private struct Constants {
        static let title = "Product List"
    }
    
    public var dataSource: ProductListDataSource
    private let productsFetcher: ProductsFetcher
    private var response: ProductsResponse?
    private var currentPage: Int = 0
    private let pageSize: Int = 10
    
    public init(collectionView: UICollectionView, titleLabel: UILabel) {
        self.dataSource = ProductListDataSource(collectionView)
        self.productsFetcher = ProductsFetcher()
        
        titleLabel.text = Constants.title
        self.loadNextProductPage()
        self.dataSource.delegate = self
    }
    
    public func updateCollectionView(for layout: ProductListLayout) {
        self.dataSource.updateContent(for: layout)
    }
    
    private func loadNextProductPage() {
        let completion: (ProductsResponse) -> Void = { [weak self] response in
            guard let self = self else {
                return
            }
            self.currentPage += 1
            DispatchQueue.main.async {
                self.response = response
                self.reloadData()
            }
        }
        
        self.productsFetcher.fetchProducts(pageNumber: self.currentPage + 1, pageSize: self.pageSize, completion: completion)
    }
    
    private func reloadData() {
        if let currentPagedSection = self.currentPagedSection {
            self.dataSource.appendPage(section: currentPagedSection)
        }
    }
    
    private var currentPagedSection: ProductListCollectionViewSection? {
        
        var pagedSection: ProductListCollectionViewSection? = nil
        var productViewModels = [ProductListCellViewModel]()
        
        self.response?.products.forEach { product in
            let viewModel = ProductListCellViewModel(product: product)
            productViewModels.append(viewModel)
        }
        
        if productViewModels.count % 2 != 0 {
            let adProduct = Product.adCellProduct()
            productViewModels.append(ProductListCellViewModel(product: adProduct))
        }
        
        if !productViewModels.isEmpty {
            pagedSection = ProductListCollectionViewSection(cellViewModels: productViewModels, pageNumber: self.currentPage)
        }
        
        return pagedSection
    }
}

extension ProductListViewModel: ProductListDataSourceDelegate {
    public func dataSource(_ dataSource: ProductListDataSource, requestsPage pageNumber: Int) {
        if pageNumber > self.currentPage {
            loadNextProductPage()
        }
    }
}
