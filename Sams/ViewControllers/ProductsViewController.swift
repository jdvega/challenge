//
//  ProductsViewController.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/26/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit

public class ProductsViewController: UIViewController {
    private struct Constants {
        static let storyboardName = "Main"
    }
    
    private var pageViewController: UIPageViewController?
    private var productsViewModel: ProductsViewModel?
    private var configureViewModel: ((UIView)->Void)?
    
    @IBOutlet var productsContainerView: UIView!
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func prepareForViewModel(pagedDataSource: PagedProductDataSource) {
        self.productsViewModel = ProductsViewModel(dataSource: pagedDataSource)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? UIPageViewController {
            destinationViewController.dataSource = self.productsViewModel
            
            if let initialViewModel = self.productsViewModel?.dataSource.initialViewModel, let firstViewController = ProductDetailPageViewController.viewControllerFromStoryboard as? ProductDetailPageViewController {
                firstViewController.configure(with: initialViewModel)
                destinationViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
            
            self.pageViewController = destinationViewController
        }
    }
}

extension ProductsViewController: StoryboardIdentifiable {
    public static var storyboardName: String {
        return Constants.storyboardName
    }
}
