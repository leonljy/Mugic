//
//  SongEditViewController.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 7. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class SongEditViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tempoTextField: UITextField!
    @IBOutlet weak var timeSignatureButton: UIButton!
    
    var song: Song? {
        didSet {
            self.nameTextField.text = song?.name
            self.tempoTextField.text = "\(song?.tempo ?? 0) bpm "
            self.timeSignatureButton.setTitle("\(song?.timeSignatureString ?? "")", for: .normal)
        }
    }
    
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
        
        
        
        if self.song == nil {
            guard let managedContext = self.managedContext else {
                return
            }
            let entity = NSEntityDescription.entity(forEntityName: "Song", in: managedContext)!
            let song = NSManagedObject(entity: entity, insertInto: managedContext) as? Song
            song?.name = "My song - \(Date())"
            self.song = song
            
        }
    }
    
    @IBAction func handleSave(_ sender: Any) {
        guard let managedContext = self.managedContext else {
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
