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
    
    var managedContext: NSManagedObjectContext? {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return nil
            }
            return appDelegate.persistentContainer.viewContext
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let managedContext = self.managedContext {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Song")
            let sort = NSSortDescriptor(key: "updatedAt", ascending: false)
            fetchRequest.sortDescriptors = [sort]
            do {
                if let songs = try managedContext.fetch(fetchRequest) as? [Song] {
                    self.songs = songs
                    self.songs?.sort { return $0.updatedAt?.compare($1.updatedAt! as Date) == .orderedDescending }
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    @IBAction func handleCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func handleAdd(_ sender: Any) {
        guard let managedContext = self.managedContext else {
            return
        }
        let entity = NSEntityDescription.entity(forEntityName: "Song", in: managedContext)!
        if let song = NSManagedObject(entity: entity, insertInto: managedContext) as? Song {
            song.name = "My song - \(Date())"
            song.updatedAt = Date() as NSDate
            self.songs?.append(song)
            self.songs?.sort { return $0.updatedAt?.compare($1.updatedAt! as Date) == .orderedDescending }
            self.save()
            self.tableView.reloadData()
        }
    }
    
    func save() {
        guard let managedContext = self.managedContext else {
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            self.showAlert(error: error)
        }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SongEditViewController") as? SongEditViewController else {
            return
        }
        
        guard let song = self.songs?[indexPath.row] else {
            return
        }
        viewController.song = song
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
