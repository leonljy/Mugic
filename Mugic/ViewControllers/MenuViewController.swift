//
//  MenuViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 6. 4..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @IBAction func handleDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MENU_CELL") as? MenuCell {
            if indexPath.row == 0  {
                cell.titleLabel.text = "리뷰 남기기"
            } else if indexPath.row == 1 {
                cell.titleLabel.text = "광고 제거하기"
            } else if indexPath.row == 2 {
                cell.titleLabel.text = "개발자에게 의견 보내기"
            } else if indexPath.row == 3 {
                cell.titleLabel.text = "앱 공유하기"
            } else {
                cell.titleLabel.text = "AT 광고"
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}
