//
//  Vector+CoreDataProperties.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-24.
//
//

import Foundation
import CoreData


public class Vector: NSManagedObject {

}

extension Vector {
    
    @NSManaged public var x1: Double
    @NSManaged public var y1: Double
    @NSManaged public var x2: Double
    @NSManaged public var y2: Double
    @NSManaged public var length: Double
    @NSManaged public var color: Data
  
}

extension Vector : Identifiable {}
