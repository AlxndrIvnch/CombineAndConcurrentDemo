//
//  TestInfo+CoreDataProperties.swift
//  Combine&ConcurrentDemo
//
//  Created by alexander.ivanchenko on 28.03.2023.
//
//

import Foundation
import CoreData


extension TestInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestInfo> {
        return NSFetchRequest<TestInfo>(entityName: "TestInfo")
    }

    @NSManaged public var time: Double
    @NSManaged public var foulderName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var images: [URL]?
    @NSManaged public var threadsCount: Int?

}

extension TestInfo : Identifiable {

}
