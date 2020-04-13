//
//  ViewController+ManagedContext.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 30/05/2019.
//  Copyright © 2019 Jeong-Uk Lee. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension UIViewController {
    var managedContext: NSManagedObjectContext? {
        get {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return nil
            }
            return appDelegate.persistentContainer.viewContext
        }
    }
}
