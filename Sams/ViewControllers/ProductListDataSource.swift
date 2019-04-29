//
//  ProductListDataSource.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/21/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import Foundation
import UIKit

public class ProductListDataSource: NSObject, UICollectionViewDataSource {
    
    private struct Constants {
        static let contentEdgeInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 0.0, right: 12.0)
        static let minimumLineSpacing: CGFloat = 10.0
        static let minimumInteritemSpacing: CGFloat = 10.0
        static let gridCellsPerRow: CGFloat = 2.0
        static let rowCellHeight: CGFloat = 300.0
    }
    
    private var collectionView: UICollectionView
    private var sectionsArray: [ProductListCollectionViewSection]
    private var layout: ProductListLayout = .grid
    public var delegate: ProductListDataSourceDelegate?
    
    public init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.sectionsArray = [ProductListCollectionViewSection]()
        super.init()
        configureCollectionView()
    }
    
    public func appendPage(section: ProductListCollectionViewSection) {
        self.sectionsArray.append(section)
        collectionView.reloadData()
    }
    
    public func updatePagedDataFor(indexPath: IndexPath) {
        if  isLastSection(indexPath) &&  isLastCellInSection(indexPath) {
            loadNextPage()
        }
    }
    
    public func updateContent(for layout: ProductListLayout) {
        self.layout = layout
        
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: true) { (finished) in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }
    
    public func viewModelFor(indexPath: IndexPath) -> ProductListCellViewModel {
        return sectionsArray[indexPath.section].cellViewModels[indexPath.row]
    }
    
    public func viewModelForIndexAfter(indexPath: IndexPath) -> IndexedProductListCellViewModel? {
        if let targetIndex = indexPathAfter(indexPath: indexPath) {
            let targetViewModel = self.viewModelFor(indexPath: targetIndex)
            return IndexedProductListCellViewModel(product: targetViewModel.product, indexPath: targetIndex)
        } else {
            return nil
        }
    }
    
    public func viewModelForIndexBefore(indexPath: IndexPath) -> IndexedProductListCellViewModel? {
        if let targetIndex = indexPathBefore(indexPath: indexPath) {
            let targetViewModel = self.viewModelFor(indexPath: targetIndex)
            return IndexedProductListCellViewModel(product: targetViewModel.product, indexPath: targetIndex)
        } else {
            return nil
        }
    }
    
}

extension ProductListDataSource {
    
    private func indexPathAfter(indexPath: IndexPath) -> IndexPath? {
        let lastItemIndex = sectionsArray[indexPath.section].cellViewModels.count - 1
        let reloadTriggerIndex = lastItemIndex - 3
        let lastSectionIndex = sectionsArray.count - 1
        var targetIndexPath: IndexPath?
        
        if indexPath.section == lastSectionIndex && indexPath.item == reloadTriggerIndex {
            loadNextPage()
        }
        
        if indexPath.item < lastItemIndex {
            let nextItem = indexPath.item + 1
            targetIndexPath = IndexPath(row: nextItem, section: indexPath.section)
        } else if indexPath.section < lastSectionIndex {
            let nextSection = indexPath.section + 1
            targetIndexPath = IndexPath(row: 0, section: nextSection)
        }
        
        return targetIndexPath
    }
    
    private func indexPathBefore(indexPath: IndexPath) -> IndexPath? {
        var targetIndexPath: IndexPath?
        
        if indexPath.item > 0 {
            let prevItem = indexPath.item - 1
            targetIndexPath = IndexPath(row: prevItem, section: indexPath.section)
        } else if indexPath.section > 0 {
            let prevSection = indexPath.section - 1
            let lastItemInPrevSection = sectionsArray[prevSection].cellViewModels.count - 1
            targetIndexPath = IndexPath(row: lastItemInPrevSection, section: prevSection)
        }
        
        return targetIndexPath
    }
    
    private func numberOfItemsInSection(_ section: Int) -> Int {
        return sectionsArray[section].cellViewModels.count
    }
    
    private func numberOfSections() -> Int {
        return sectionsArray.count
    }
}

extension ProductListDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItemsInSection(section)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.reuseIdentifer, for: indexPath) as! ProductListCollectionViewCell
        
        cell.configure(viewModelFor(indexPath: indexPath), layout: self.layout)
        
        return cell
    }
}

extension ProductListDataSource {
    
    public func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth(indexPath: indexPath), height: cellHeight(indexPath: indexPath))
    }
    
    public func insetForSectionAt(section: Int) -> UIEdgeInsets {
        return Constants.contentEdgeInsets
    }
    
    public func minimumLineSpacingForSectionAt(section: Int) -> CGFloat {
        return Constants.minimumLineSpacing
    }
    
    public func minimumInteritemSpacingForSectionAt(section: Int) -> CGFloat {
        return Constants.minimumInteritemSpacing
    }
}

extension ProductListDataSource {
    
    private func isLastSection(_ indexPath: IndexPath) -> Bool {
        return self.sectionsArray.count == indexPath.section + 1
    }
    
    private func isLastCellInSection(_ indexPath: IndexPath) -> Bool {
        return sectionsArray[indexPath.section].cellViewModels.count == indexPath.row + 1
    }
    
    private func loadNextPage() {
        self.delegate?.dataSource(self, requestsPage: nextPageNumber)
    }
    
    private var nextPageNumber: Int {
        return self.sectionsArray.count + 1
    }
}

extension ProductListDataSource {
    
    private func configureCollectionView() {
        self.collectionView.dataSource = self
        let nib = ProductListCollectionViewCell.nib
        self.collectionView.register(nib, forCellWithReuseIdentifier: ProductListCollectionViewCell.reuseIdentifer)
    }
    
    private func cellWidth(indexPath: IndexPath) -> CGFloat {
        let marginWidth = Constants.contentEdgeInsets.left + Constants.contentEdgeInsets.right
        let totalWidth = collectionView.frame.size.width
        
        switch self.layout {
        case .grid:
            let totalXOffset = marginWidth + Constants.minimumInteritemSpacing
            return (totalWidth - totalXOffset)/Constants.gridCellsPerRow
        case .row:
            return totalWidth - marginWidth
        }
    }
    
    private func cellHeight(indexPath: IndexPath) -> CGFloat  {
        switch self.layout {
        case .grid:
            return cellWidth(indexPath: indexPath)
        case .row:
            return Constants.rowCellHeight
        }
    }
}
