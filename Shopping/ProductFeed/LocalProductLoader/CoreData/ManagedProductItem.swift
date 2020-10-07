//
//  ManagedProductItem.swift
//  Shopping
//
//  Created by Carlos Fernandez on 06/10/2020.
//

import CoreData

@objc(ManagedProductItem)
class ManagedProductItem: NSManagedObject {
    @NSManaged var code: String
    @NSManaged var name: String
    @NSManaged var price: Float
}

extension ManagedProductItem {
    static func first(with code: String, in context: NSManagedObjectContext) throws ->ManagedProductItem? {
        let request = NSFetchRequest<ManagedProductItem>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedProductItem.code)])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func products(from localProducts: [LocalProductItem], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localProducts.map({ local in
            let managed = ManagedProductItem(context: context)
            managed.code = local.code
            managed.name = local.name
            managed.price = local.price
            return managed
        }))
    }
    
    var local: LocalProductItem {
        return LocalProductItem(code: code, name: name, price: price)
    }
}
