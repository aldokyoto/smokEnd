//
//  DatosBD+CoreDataProperties.swift
//  SmokeEndModel
//
//  Created by Aldo Mateos on 12/6/16.
//  Copyright © 2016 Aldo Kyoto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DatosBD {

    @NSManaged var cigarrosFumados: NSNumber?
    @NSManaged var precioPaquete: NSNumber?
    @NSManaged var cigarrosPulsados: NSNumber?

}
