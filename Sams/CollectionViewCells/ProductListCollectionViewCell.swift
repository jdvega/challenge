//
//  ProductListCollectionViewCell.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/22/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit
import WebKit

public class ProductListCollectionViewCell: UICollectionViewCell, ReuseIdentifiable, NibNamable {

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var starRatingLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var imageView: DynamicImageView!
    @IBOutlet var inStockLabel: UILabel!
    @IBOutlet var discriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet var descriptionTextView: UITextView!
    
    public var viewModel: ProductListCellViewModel?
    private var layout: ProductListLayout = .grid
    
    public override func prepareForReuse() {
        imageView.cancelDownload()
        imageView.image = nil
        self.productNameLabel.text = nil
        self.starRatingLabel.text = nil
        self.priceLabel.text = nil
        self.inStockLabel.text = nil
        self.descriptionTextView.text = nil
    }
    
    public func configure(_ viewModel: ProductListCellViewModel, layout: ProductListLayout) {
        
        self.viewModel = viewModel
        
        if viewModel.isAdCell {
            configureAsAd()
            return
        }
        
        if case layout = self.layout {
            prepareForReuse()
        }
        
        self.layout = layout
        updateContraintsForLayout()
        assignText()
        DispatchQueue.global(qos: .utility).async {
            self.loadImage()
        }
    }
    
    public func configureAsAd() {
        if let image = viewModel?.adImage {
            imageView.image = image
        }
        self.priceLabel.text = viewModel?.adPriceLabelText
        self.starRatingLabel.text = viewModel?.adRatingLabelText
        self.descriptionTextView.text = viewModel?.descriptionText
    }
    
    private func assignText() {
        self.productNameLabel.text = viewModel?.productName
        self.starRatingLabel.text = viewModel?.ratingAndReview
        self.priceLabel.text = viewModel?.priceString
        self.inStockLabel.text = viewModel?.inStockString
        if case .row = self.layout {
            self.descriptionTextView.text = viewModel?.descriptionText
        }
    }
    
    private func updateContraintsForLayout() {
        switch self.layout {
        case .grid:
            discriptionHeightConstraint.isActive = true
        case .row:
            discriptionHeightConstraint.isActive = false
        }
    }
    
    private func loadImage() {
        guard let imageURL = viewModel?.imageURL else {
            return
        }
        self.imageView.applyCornerRadius()
        self.imageView.downloadImage(url: imageURL, completion: nil)
    }
}
