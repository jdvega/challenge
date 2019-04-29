//
//  ProductDetailPageViewController.swift
//  Sams
//
//  Created by Jaime D. Vega on 4/26/19.
//  Copyright © 2019 JD Vega. All rights reserved.
//

import UIKit
import MessageUI

public class ProductDetailPageViewController: UIViewController {
    
    private struct Constants {
        static let viewModelErrorMessage = "FatalError: ProductDetailPageViewModel is not initialized for ProductDetailPageViewController"
        static let storyboardName = "Main"
        static let checkItOut = "Check This Out!"
        static let emailMsgBodyPrefix = "I want this: "
        static let emailMsgBodySuffix = "!"
        static let emailDialogTitle = "Mail is unavailable"
        static let emailDialogMsg = "Your device is not set up to use email at this time."
        static let emailDiallogButtonTitle = "Ok"
        static let phoneDialogTitle = "Order By Phone"
        static let phoneDialogMessage = "Would you like to call customer service and speak with a sales associate?"
        static let phoneDialogYesButtonTitle = "Yes"
        static let phoneDialogNoButtonTitle = "No"
    }
    
    @IBOutlet var productImageView: DynamicImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productRatingReviewsLabel: UILabel!
    @IBOutlet var inStockLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    var viewModel: ProductDetailPageViewModel?
    
    @IBAction func phoneButtonTapped(_ sender: Any) {
        
        let completion: (UIAlertAction) -> Void = { [weak self] _ in
            self?.safeViewModel.callCustomerService()
        }
        
        presentAlert(completion: completion)
    }
    
    @IBAction func mailButtonTapped(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setSubject(Constants.checkItOut)
            mail.setMessageBody(Constants.emailMsgBodyPrefix + self.safeViewModel.productName + Constants.emailMsgBodySuffix, isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: Constants.emailDialogTitle, message: Constants.emailDialogMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Constants.emailDiallogButtonTitle, style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    public func configure(with viewModel: ProductDetailPageViewModel) {
        self.viewModel = viewModel
    }
    
    private func presentAlert(completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: Constants.phoneDialogTitle, message: Constants.phoneDialogMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constants.phoneDialogYesButtonTitle, style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: Constants.phoneDialogNoButtonTitle, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func configureAsAd() {
        if let image = safeViewModel.adImage {
            self.productImageView.image = image
        }
        self.productNameLabel.text = safeViewModel.adDescriptionText
        self.priceLabel.text = safeViewModel.adPriceLabelText
        self.productRatingReviewsLabel.text = safeViewModel.adRatingLabelText
        self.inStockLabel.text = nil
        self.descriptionTextView.text = nil
        self.descriptionTextView.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if safeViewModel.isAdCell {
            self.configureAsAd()
            return
        }
        assignText()
        loadImage()
    }
    
    private func assignText() {
        self.productNameLabel.text = self.safeViewModel.productName
        self.productRatingReviewsLabel.text = self.safeViewModel.ratingAndReview
        self.inStockLabel.text = self.safeViewModel.inStockString
        self.priceLabel.text = self.safeViewModel.priceString
        self.descriptionTextView.text = self.safeViewModel.descriptionText
        self.descriptionTextView.applyCornerRadius(borderColor: UIColor.darkGray.cgColor)
    }
    
    private func loadImage() {
        guard let imageURL = viewModel?.imageURL else {
            return
        }
        self.productImageView.applyCornerRadius()
        self.productImageView.downloadImage(url: imageURL, completion: nil)
    }
    
    private var safeViewModel: ProductDetailPageViewModel {
        guard let safeViewModel = self.viewModel else {
            fatalError(Constants.viewModelErrorMessage)
        }
        return safeViewModel
    }
}

extension ProductDetailPageViewController: StoryboardIdentifiable {
    public static var storyboardName: String {
        return Constants.storyboardName
    }
}
