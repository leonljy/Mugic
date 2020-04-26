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
        
        self.customizeNavigationBarAppearance()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
        song.updatedAt = Date()
        self.save()
        
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
        self.managedContext?.delete(song)
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
