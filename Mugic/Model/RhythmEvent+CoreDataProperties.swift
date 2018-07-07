//
//  RhythmEvent+CoreDataProperties.swift
//  Mugic
//
//  Created by Jeong-Uk Lee on 2018. 7. 7..
//  Copyright © 2018년 Jeong-Uk Lee. All rights reserved.
//
//

import Foundation
import CoreData


extension RhythmEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RhythmEvent> {
        return NSFetchRequest<RhythmEvent>(entityName: "RhythmEvent")
    }

    @NSManaged public var beat: Int16

}
