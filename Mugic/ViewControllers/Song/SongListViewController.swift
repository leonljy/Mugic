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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Song> = {
        let fetchRequest: NSFetchRequest = Song.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Song.updatedAt, ascending: true),
        ]
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure()
        }

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: delegate.persistentContainer.viewContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }

        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        self.customizeNavigationBarAppearance()    
    }
    
    func customizeNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        guard let titleFont = UIFont(name: "Montserrat-Italic", size: 20) else { return }
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.foregroundColor: UIColor.mugicMain
        ]
        appearance.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.tintColor = UIColor.mugicMain
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: titleFont,
            NSAttributedString.Key.foregroundColor: UIColor.mugicMain
        ]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func handleMenu() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            return
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func handleAdd(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isProVersion") {
            //Proversion
            self.addNewSong()
        } else {
            //No proversion
            let limit = 2
            guard let count = self.fetchedResultsController.fetchedObjects?.count else {
                return
            }
            
            if count < limit {
                self.addNewSong()
            } else {
                self.showTooManySongAlert()
            }
        }
    }
    
    func addNewSong() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let song = Song(context: appDelegate.persistentContainer.viewContext)
        song.name = "New song"
        song.updatedAt = Date()
        self.save()
    }
    
    func showTooManySongAlert() {
        let alertController = UIAlertController(title: "Oops!!", message: "To add more songs pro version upgrade now.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "No thanks", style: .default, handler: { _ in }))
        alertController.addAction(UIAlertAction(title: "LEARN MORE", style: .default, handler: { _ in
            guard let navigationController = UIStoryboard(name: "Menu", bundle: nil).instantiateInitialViewController() as? UINavigationController else {
                return
            }
//            guard let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() else {
//                return
//            }
//            navigationController.pushViewController(viewController, animated: true)
            self.present(navigationController, animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.saveContext()
    }
}

extension SongListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as? SongTableViewCell else {
            return UITableViewCell()
        }
        guard let song = self.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }
        cell.song = song
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let songs = self.fetchedResultsController.fetchedObjects else {
            return 0
        }
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let song = self.fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.persistentContainer.viewContext.delete(song)
        self.save()
    }
}


extension SongListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mainViewController = UIStoryboard(name: "SongDetail", bundle: nil).instantiateInitialViewController() as? SongDetailViewController else { return }
        guard let song = self.fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
        mainViewController.song = song
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
}

extension SongListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
}
