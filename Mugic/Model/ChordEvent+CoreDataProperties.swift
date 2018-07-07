//
//  ChordEvent+CoreDataProperties.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 7. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//
//

import Foundation
import CoreData


extension ChordEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChordEvent> {
        return NSFetchRequest<ChordEvent>(entityName: "ChordEvent")
    }

    @NSManaged public var baseNote: Int16
    @NSManaged public var chord: Int16

}
