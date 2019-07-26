//
//  SongListViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 7. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SongListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var songs: [Song]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.loadSongs()
    }
    
    func loadSongs() {
        guard let managedContext = self.managedContext else {
            return
        }
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        let sort = NSSortDescriptor(key: "updatedAt", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            self.songs = try managedContext.fetch(fetchRequest)
            self.songs?.sort { return $0.updatedAt?.compare($1.updatedAt! as Date) == .orderedDescending }
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func handleAdd(_ sender: Any) {
        guard let managedContext = self.managedContext else {
            return
        }
        let song = Song(context: managedContext)
        song.name = "New song"
        song.updatedAt = Date() as NSDate
        self.songs?.append(song)
        self.save()
        self.loadSongs()
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.coreDataStack.saveContext()
    }
}

extension SongListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as? SongTableViewCell else {
            return UITableViewCell()
        }
        guard let song = self.songs?[indexPath.row] else {
            return cell
        }
        cell.nameLabel.text = song.name
        cell.tempoLabel.text = "\(song.tempo) BPM"
        cell.timeSignatureLabel.text = song.timeSignatureString
        cell.trackCountLabel.text = "\(song.tracks?.count ?? 0) track(s)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let songs = self.songs else {
            return 0
        }
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let song = self.songs?[indexPath.row], editingStyle == .delete else {
            return
        }
        self.managedContext?.delete(song)
        
        self.save()
        self.songs?.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
}


extension SongListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController, let song = self.songs?[indexPath.row] else {
            return
        }
        mainViewController.song = song
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
}
