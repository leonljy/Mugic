//
//  MenuViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 6. 4..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import MessageUI

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let mugicURL = "https://itunes.apple.com/us/app/id1390991641"
    let atURL = "itms://itunes.apple.com/us/app/id976019182"
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadProducts()
    }
    
    func reloadProducts() {
        IAPHelper.store.requestProducts { (success, products) in
            guard success, let products = products else {
                return
            }
            self.products = products
            self.tableView.reloadData()
        }
    }
    
    @IBAction func handleDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}


extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.products.count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MENU_CELL") as? MenuCell {
            if indexPath.section == 0 {
                let product = self.products[indexPath.row]
                cell.titleLabel.text = product.localizedTitle
            } else {
                if indexPath.row == 0  {
                    cell.titleLabel.text = "Write review for Mugic"
                } else if indexPath.row == 1 {
                    cell.titleLabel.text = "Restore Purchase"
                } else if indexPath.row == 2 {
                    cell.titleLabel.text = "Mail to developer"
                } else if indexPath.row == 3 {
                    cell.titleLabel.text = "Share Mugic to friends"
                } else {
                    cell.titleLabel.text = "AT"
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.isSelected = false
        }
        if indexPath.section == 0 {
            let product = self.products[indexPath.row]
            IAPHelper.store.buyProduct(product)
        } else {
            if indexPath.row == 0  {
                SKStoreReviewController.requestReview()
            } else if indexPath.row == 1 {
                IAPHelper.store.restorePurchases()
            } else if indexPath.row == 2 {
                if MFMailComposeViewController.canSendMail() {
                    self.presentMailComposeViewController()
                }
            } else if indexPath.row == 3 {
                let activityViewController = UIActivityViewController(activityItems: [URL(string: self.mugicURL)!], applicationActivities: nil)
                present(activityViewController, animated: true, completion: nil)
            } else {
                UIApplication.shared.open(URL(string: self.atURL)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    func presentMailComposeViewController() {
        let deviceModel =  UIDevice.current.modelName
        let osVersion = UIDevice.current.systemVersion
        let appVersion = String(describing: Bundle.main.infoDictionary?["CFBundleVersion"] ?? NSNull())
        
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = self
        viewController.setToRecipients(["leonljy@gmail.com"])
        viewController.setSubject("Mugic - iOS Support")
        viewController.setMessageBody("\n\n\n\n\n🎼🎸🎹🎧🎻🥁🎷🎺\nMugic: \(appVersion)\niOS: \(osVersion)\nDevice: \(deviceModel)", isHTML: false)
        self.present(viewController, animated: true, completion: nil)
    }
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}
