//
//  ManagedProductPersistance.swift
//  Shopping
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import CoreData

@objc(ManagedProductFeed)
class ManagedProductFeed: NSManagedObject {
    @NSManaged var timeStamp: Date
    @NSManaged var feed: NSOrderedSet
}

extension ManagedProductFeed {
    static func find(in context: NSManagedObjectContext) throws -> ManagedProductFeed? {
        let request = NSFetchRequest<ManagedProductFeed>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedProductFeed {
        try find(in: context).map(context.delete)
        return ManagedProductFeed(context: context)
    }
    
    var localFeed: [LocalProductItem] {
        return feed.compactMap { ($0 as? ManagedProductItem)?.local }
    }
}
