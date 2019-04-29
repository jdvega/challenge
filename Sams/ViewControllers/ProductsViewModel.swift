//
//  ProductsViewModel.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/26/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

public class ProductsViewModel: NSObject {
    
    public let dataSource: PagedProductDataSource
    
    public init(dataSource: PagedProductDataSource) {
        self.dataSource = dataSource
    }
    
    private func productDetailViewController(viewModel: ProductDetailPageViewModel?) -> ProductDetailPageViewController? {
        if let viewModel = viewModel, let viewController = ProductDetailPageViewController.viewControllerFromStoryboard as? ProductDetailPageViewController {
            viewController.configure(with: viewModel)
            return viewController
        } else {
            return nil
        }
    }
}

extension ProductsViewModel: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ProductDetailPageViewController, let indexPath = viewController.viewModel?.indexPath {
            return productDetailViewController(viewModel: self.dataSource.prevViewModel(from: indexPath))
        } else {
            return nil
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ProductDetailPageViewController, let indexPath = viewController.viewModel?.indexPath {
            return productDetailViewController(viewModel: self.dataSource.nextViewModel(from: indexPath))
        } else {
            return nil
        }
    }
}
