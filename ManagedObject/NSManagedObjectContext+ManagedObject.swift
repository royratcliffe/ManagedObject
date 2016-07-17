// ManagedObject NSManagedObjectContext+ManagedObject.swift
//
// Copyright © 2015, 2016, Roy Ratcliffe, Pioneering Software, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS,” WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

import CoreData

extension NSManagedObjectContext {

  /// Fetches an entity by name.
  /// - parameter entityName: Name of the entity to fetch.
  /// - returns: Array of fetched objects.
  ///
  /// Builds a fetch request using the given entity name. Executes the fetch
  /// request within this context. Answers the resulting array of managed
  /// objects. Throws on error.
  public func fetchAll<Result: NSFetchRequestResult>(_ entityName: String) throws -> [Result] {
    let request = NSFetchRequest<Result>(entityName: entityName)
    return try fetch(request)
  }

  /// Fetches all managed objects using an entity type. Requires that the
  /// managed-object context contains an entity description matching the entity
  /// class' last class-name component.
  /// - returns: An array of entity types, or `nil` if the array of managed
  ///   objects cannot convert to an array of the required entities. Only throws
  ///   if there was an error during the fetch.
  public func fetchAll<Entity: NSManagedObject>(_ entityType: Entity.Type) throws -> [Entity]? {
    return try fetchAll(entityType.entityName)
  }

  /// Finds the first entity whose key matches a value.
  /// - returns: Optional matching managed object.
  ///
  /// Implementation constructs the comparison predicate programmatically in
  /// order to avoid any issues with escaping string literals. Instead, let the
  /// `NSExpression` handle those machinations.
  public func fetchFirst<Result: NSFetchRequestResult>(_ entityName: String,
                         by keyPath: String,
                         value: AnyObject) throws -> Result? {
    let request = NSFetchRequest<Result>(entityName: entityName)
    request.predicate = ComparisonPredicate(
      leftExpression: NSExpression(forKeyPath: keyPath),
      rightExpression: NSExpression(forConstantValue: value),
      modifier: .direct,
      type: .equalTo,
      options: [])
    request.fetchLimit = 1
    return try fetch(request).first
  }

  /// Fetches the first `fetchLimit` managed objects, first _one_ by default.
  public func fetchFirst<Result: NSFetchRequestResult>(_ entityName: String, fetchLimit: Int = 1) throws -> [Result] {
    let request = NSFetchRequest<Result>(entityName: entityName)
    request.fetchLimit = fetchLimit
    return try fetch(request)
  }

  /// Fetches the first _n_ objects by entity type.
  /// - parameter entityType: Sub-class of `NSManagedObject` that represents an
  ///   entity within this context's data model. The model must contain an
  ///   entity description matching this type's class name (without any module
  ///   prefix).
  /// - parameter fetchLimit: Number of entities to fetch at most, one by
  ///   default.
  /// - returns: An array of fetched entities, zero or more, or `nil` if the
  ///   fetched array does not convert to entities of the appropriate type.
  public func fetchFirst<Entity: NSManagedObject>(_ entityType: Entity.Type, fetchLimit: Int = 1) throws -> [Entity]? {
    return try fetchFirst(entityType.entityName)
  }

  /// Inserts a new object.
  /// - parameter entityName: Name of the entity to insert.
  /// - returns: New inserted object.
  ///
  /// If entityName does not exist in the data model, CoreData will throw an
  /// internal consistency exception (NSInternalInconsistencyException) for the
  /// reason that CoreData cannot find the named entity within the model.
  public func insertNewObject(_ entityName: String) -> NSManagedObject {
    return NSEntityDescription.insertNewObject(forEntityName: entityName, into: self)
  }

  /// - returns: a new child managed-object context with private-queue or
  ///   main-queue concurrency. The receiver context becomes the new context's
  ///   parent.
  public func newChildContext(_ concurrencyType: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: concurrencyType)
    context.parent = self
    return context
  }

}
