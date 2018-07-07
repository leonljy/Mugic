//
//  MelodicEvent+CoreDataProperties.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 7. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//
//

import Foundation
import CoreData


extension MelodicEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MelodicEvent> {
        return NSFetchRequest<MelodicEvent>(entityName: "MelodicEvent")
    }

    @NSManaged public var note: Int16

}
