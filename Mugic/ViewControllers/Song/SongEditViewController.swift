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
    @IBOutlet weak var pickerViewBackground: UIView!
    
    var song: Song?
    @IBOutlet weak var pickerView: UIPickerView!
    
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
        
        self.nameTextField.delegate = self
        self.tempoTextField.delegate = self
        self.nameTextField.text = song?.name
        self.tempoTextField.text = "\(song?.tempo ?? 0)"
        
        self.timeSignatureButton.setTitle("\(song?.timeSignatureString ?? "")", for: .normal)
        self.pickerView.delegate = self as UIPickerViewDelegate
        self.pickerView.dataSource = self as UIPickerViewDataSource
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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

extension SongEditViewController: UITextFieldDelegate {
    
    @IBAction func handleNameChanged(_ sender: Any) {
        self.song?.name = self.nameTextField.text
        self.save()
    }
    
    @IBAction func handleTempoChanged(_ sender: Any) {
        guard let tempoString = self.tempoTextField.text, let tempo = Int16(tempoString), tempo > 0, tempo < 500 else {
            return
        }
        self.song?.tempo = tempo
        self.save()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension SongEditViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TimeSignature.TwoTwo.rawValue + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let type = TimeSignature(rawValue: row) else {
            return ""
        }
        return Song.timeSignatureString(type: type)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.song?.timeSignature = Int16(row)
        self.save()
        self.timeSignatureButton.setTitle("\(song?.timeSignatureString ?? "")", for: .normal)
    }
    
    @IBAction func handleTimeSignature(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.pickerViewBackground.alpha = 1.0
        }
    }
    
    @IBAction func handleDismissPickerView(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.pickerViewBackground.alpha = 0.0
        }
    }
}
