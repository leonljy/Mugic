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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func handleDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if UserDefaults.standard.bool(forKey: "isProVersion") {
            return 1
        } else {
            return 2
        }
    }
}


extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if UserDefaults.standard.bool(forKey: "isProVersion") {
                return 0
            } else {
                return 1
            }
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as? MenuCell {
            if indexPath.section == 0 {
                cell.titleLabel.text = "Purchase Pro Version"
            } else {
                if indexPath.row == 0  {
                    cell.titleLabel.text = "Write review for Mugic"
                } else if indexPath.row == 1 {
                    cell.titleLabel.text = "Restore Purchase"
                } else {
                    cell.titleLabel.text = "Mail to developer"
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
            AccountManager.shared.purchase { (error) in
                if error != nil {
                    //TODO: Alert Action
                    print(error!)
                    return
                }
                
                //TODO: Completion Handler
            }
        } else {
            if indexPath.row == 0  {
                //TODO: Request review
//                SKStoreReviewController.requestReview(in: sel)
            } else if indexPath.row == 1 {
                AccountManager.shared.restore { (error) in
                    if error != nil {
                        //TODO: Alert Action
                        print(error!)
                        return
                    }
                    
                    //TODO: Completion Handler
                }
            } else {
                if MFMailComposeViewController.canSendMail() {
                    self.presentMailComposeViewController()
                }
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


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
