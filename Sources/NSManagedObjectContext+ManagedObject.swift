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
                         value: Any) throws -> Result? {
    let request = NSFetchRequest<Result>(entityName: entityName)
    request.predicate = NSComparisonPredicate(
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

  /// Inserts a new object by its entity type.
  /// - parameter entityType: Managed-object sub-class representing the entity.
  /// - returns: New instance of managed-object sub-class, or `nil` if new
  ///   instance did not successfully convert to the given sub-class.
  public func insertNewObject<Entity: NSManagedObject>(entityType: Entity.Type) -> Entity? {
    return NSEntityDescription.entity(forEntityName: entityType.entityName, in: self) as? Entity
  }

  /// - returns: a new child managed-object context with private-queue or
  ///   main-queue concurrency. The receiver context becomes the new context's
  ///   parent.
  public func newChildContext(_ concurrencyType: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: concurrencyType)
    context.parent = self
    return context
  }

  /// Returns all the parents of this context. Answers an array of contexts, an
  /// empty array if no parents. The result does *not* include this context.
  public var parents: [NSManagedObjectContext] {
    var parents = [NSManagedObjectContext]()
    var context = parent
    while context != nil {
      parents.append(context!)
      context = context!.parent
    }
    return parents
  }

  /// Adds a block observer to this context that automatically merges changes
  /// from the given context whenever that context saves. Adds a new observer to
  /// the default notification centre. The merging block runs in the given
  /// operation queue, if given.
  /// - parameter context: Managed-object context to observe and merge from.
  /// - parameter queue: Optional operation queue on which to request the merge.
  /// - returns: An opaque observer object representing the merging block. Use
  ///   this to remove it.
  public func automaticallyMergesChanges(from context: NSManagedObjectContext, queue: OperationQueue? = nil) -> NSObjectProtocol {
    let center = NotificationCenter.default
    let name = Notification.Name.NSManagedObjectContextDidSave
    return center.addObserver(forName: name, object: context, queue: queue) { [weak self] (notification) in
      self?.mergeChanges(fromContextDidSave: notification)
    }
  }

  /// Sets up automatic change merging for this context from all *direct* child
  /// contexts. Observes all context will-save notifications. Filters the
  /// notifications for contexts where the parent's identity matches this
  /// context.
  /// - parameter queue: Optional operation queue on which to merge changes.
  public func automaticallyMergesChangesFromChildren(queue: OperationQueue? = nil) -> NSObjectProtocol {
    return automaticallyMergesChanges(queue: queue) { (from, to) in
      from.parent === to
    }
  }

  public typealias ShouldMergeChanges = @escaping (
    _ from: NSManagedObjectContext,
    _ to: NSManagedObjectContext
  ) -> Bool

  /// Sets up a merge-changes observer based on a given condition block. Merging
  /// only occurs if the condition block answers `true`, given the context that
  /// merging will take changes from, as well as the context into which the
  /// changes will merge.
  /// - parameter queue: Optional operation queue on which to merge changes.
  /// - parameter shouldMergeChanges: Escaping capture that answers `true` if
  ///   the merge should proceed. Its two arguments provide the context with
  ///   changes that might be merged followed by the context to which the
  ///   changes will merge if the capture answers `true`. The capture runs in
  ///   another thread.
  /// - parameter from: Context to merge changes from.
  /// - parameter to: Context for merging to.
  public func automaticallyMergesChanges(queue: OperationQueue? = nil,
                                         shouldMergeChanges: ShouldMergeChanges) -> NSObjectProtocol {
    return NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextDidSave,
                                                  object: nil,
                                                  queue: queue) { [weak self] (notification) in
      guard let to = self,
            let from = notification.object as? NSManagedObjectContext,
            shouldMergeChanges(from, to) else {
        return
      }
      to.mergeChanges(fromContextDidSave: notification)
    }
  }

  /// Sets up an observer block for context-will-save notifications. Updates
  /// `createdAt` with the current date and time when the context sees a newly
  /// inserted object. Updates `updatedAt` when the context sees an
  /// update. Ignores deletions. Only stamps those objects that respond to
  /// setters for the created- and updated-at dates.
  public func automaticallyUpdatesTimestamps(queue: OperationQueue? = nil) -> NSObjectProtocol {
    let center = NotificationCenter.default
    let name = Notification.Name.NSManagedObjectContextWillSave
    return center.addObserver(forName: name, object: self, queue: queue) { [weak self] (_) in
      self?.insertedObjects.filter {
        $0.responds(to: Selector(("setCreatedAt:")))
      }.forEach {
        $0.setValue(Date(), forKey: "createdAt")
      }
      self?.updatedObjects.filter {
        $0.responds(to: Selector(("setUpdatedAt:")))
      }.forEach {
        $0.setValue(Date(), forKey: "updatedAt")
      }
    }
  }

}
