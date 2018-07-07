//
//  SongListViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 7. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit

class SongListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var songs: [Song]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handleAdd(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SongEditViewController") as? SongEditViewController else {
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SongListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as? SongTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let songs = self.songs else {
//            return 0
//        }
//        return songs.count
        return 1
    }
}


extension SongListViewController: UITableViewDelegate {
    
}
