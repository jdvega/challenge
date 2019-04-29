//
//  ProductListViewController.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/21/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    private struct Constants {
        static let viewModelErrorMessage = "ProductListViewModel is not initialized for ProductListViewController"
    }
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var layoutSegmentedControl: UISegmentedControl!
    
    public var viewModel: ProductListViewModel?
    public var configureViewModel: ((UICollectionView, UILabel) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModel = { [weak self] collectionView, label in
            collectionView.delegate = self
            self?.viewModel = ProductListViewModel(collectionView: collectionView, titleLabel: label)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let configClosure = configureViewModel {
            configClosure(collectionView, titleLabel)
            self.headerView.applyHorizontalBorder(type: .bottom)
            self.footerView.applyHorizontalBorder(type: .top)
        }
        configureViewModel = nil
    }
    
    @IBAction func updateLayout(_ sender: Any) {
        guard let layout = ProductListLayout(rawValue: self.layoutSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        self.viewModel?.updateCollectionView(for: layout)
    }
    
    private var safeViewModel: ProductListViewModel {
        guard let viewModel = viewModel else {
            fatalError(Constants.viewModelErrorMessage)
        }
        return viewModel
    }
    
    private var dataSource: ProductListDataSource {
        return safeViewModel.dataSource
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let productsViewController = ProductsViewController.viewControllerFromStoryboard as? ProductsViewController {
            let pagedDataSource = PagedProductDataSource(listDataSource: dataSource, initial: indexPath)
            productsViewController.prepareForViewModel(pagedDataSource: pagedDataSource)
            self.present(productsViewController, animated: true, completion: nil)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dataSource.sizeForItemAt(indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return dataSource.insetForSectionAt(section: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return dataSource.minimumLineSpacingForSectionAt(section: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return dataSource.minimumInteritemSpacingForSectionAt(section: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.dataSource.updatePagedDataFor(indexPath: indexPath)
    }
}
