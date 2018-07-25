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
    
    var song: Song?
    
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
        
        self.nameTextField.text = song?.name
        self.tempoTextField.text = "\(song?.tempo ?? 0)"
        self.timeSignatureButton.setTitle("\(song?.timeSignatureString ?? "")", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let managedContext = self.managedContext else {
            return
        }
        
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            self.showAlert(error: error)
        }
    }
    
    
    
}
