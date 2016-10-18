// ManagedObject FetchedResults.swift
//
// Copyright © 2016, Roy Ratcliffe, Pioneering Software, United Kingdom
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

import Foundation
import CoreData

open class FetchedResults<Result: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, NSMutableCopying {

  public typealias Request = NSFetchRequest<Result>

  public typealias Controller = NSFetchedResultsController<Result>

  var controller: Controller?

  public weak var delegate: NSFetchedResultsControllerDelegate?

  public func request(objectID: NSManagedObjectID) {
    request = FetchedResults.request(for: objectID)
  }

  public func request(object: NSManagedObject) {
    request(objectID: object.objectID)
    if let context = object.managedObjectContext {
      self.context = context
    }
  }

  public var request: Request? {
    didSet {
      if request != oldValue {
        setUpController()
      }
    }
  }

  public var context: NSManagedObjectContext? {
    didSet {
      if context != oldValue {
        setUpController()
      }
    }
  }

  public var sectionNameKeyPath: String? {
    didSet {
      if sectionNameKeyPath != oldValue {
        setUpController()
      }
    }
  }

  public var cacheName: String? {
    didSet {
      if cacheName != oldValue {
        setUpController()
      }
    }
  }

  func setUpController() {
    guard let request = request else { return }
    guard let context = context else { return }
    tearDownController()
    let newController = Controller(fetchRequest: request,
                                   managedObjectContext: context,
                                   sectionNameKeyPath: sectionNameKeyPath,
                                   cacheName: cacheName)
    newController.delegate = self
    controller = newController
  }

  func tearDownController() {
    controller?.delegate = nil
    controller = nil
  }

  /// - parameter indexPath: Section and row index of fetched object.
  /// - returns: the fetched object at the given index path. Answers `nil` if no
  ///   controller set up.
  public func object(at indexPath: IndexPath) -> Result? {
    return controller?.object(at: indexPath)
  }

  /// - parameter object: Fetched object to look up.
  /// - returns: Index path (section and row index) of the fetched object, or
  ///   `nil` if no controller.
  public func indexPath(forObject object: Result) -> IndexPath? {
    return controller?.indexPath(forObject: object)
  }

  public var fetchedObject: Result? {
    return fetchedObjects.first
  }

  /// Answers the first prefetched object, or the only object if the request's
  /// fetch limit is 1. Answers `nil` if there are no fetched objects.
  public var prefetchedObject: Result? {
    return prefetchedObjects.first
  }

  /// Answers all the fetched objects, or an empty array if no previous fetch.
  public var fetchedObjects: [Result] {
    return controller?.fetchedObjects ?? []
  }

  /// Prefetches and answers all fetched objects. Does not fetch any objects if
  /// already fetched.
  public var prefetchedObjects: [Result] {
    prefetch()
    return fetchedObjects
  }

  /// Tries to perform a fetch. Logs any error to the debug console when in
  /// debug mode. Does nothing if no controller yet set up.
  public func tryFetch() {
    do {
      try controller?.performFetch()
    } catch let error as NSError {
      #if DEBUG
        NSLog("%@", error)
      #endif
    }
  }

  /// Fetches unless the controller has already fetched. Does nothing otherwise,
  /// or if no controller.
  public func prefetch() {
    if let controller = controller {
      if controller.fetchedObjects == nil {
        tryFetch()
      }
    }
  }

  /// True if the controller has fetched objects. False if no fetched objects,
  /// or no controller.
  public var hasFetched: Bool {
    guard let controller = controller else { return false }
    return controller.fetchedObjects != nil
  }

  /// Disconnects the fetched-results controller.
  deinit {
    controller?.delegate = nil
  }

  /// Entity name for these fetched results based on result type.
  public static var entityName: String {
    return String(describing: Result.self)
  }

  /// New fetch request using entity name.
  open static func requestForEntity() -> Request {
    return Request(entityName: entityName)
  }

  public static func request(for objectID: NSManagedObjectID) -> Request {
    let request = FetchedResults.requestForEntity()
    request.predicate = NSPredicate(format: "SELF = %@", objectID)
    request.sortDescriptors = [NSSortDescriptor(key: "SELF", ascending: false)]
    request.fetchLimit = 1
    return request
  }

  //----------------------------------------------------------------------------
  // MARK: - Fetched Results Controller Delegate
  //----------------------------------------------------------------------------

  public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                         didChange anObject: Any,
                         at indexPath: IndexPath?,
                         for type: NSFetchedResultsChangeType,
                         newIndexPath: IndexPath?) {
    delegate?.controller?(controller,
                          didChange: anObject,
                          at: indexPath,
                          for: type,
                          newIndexPath: newIndexPath)
  }

  public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                         didChange sectionInfo: NSFetchedResultsSectionInfo,
                         atSectionIndex sectionIndex: Int,
                         for type: NSFetchedResultsChangeType) {
    delegate?.controller?(controller,
                          didChange: sectionInfo,
                          atSectionIndex: sectionIndex,
                          for: type)
  }

  public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.controllerWillChangeContent?(controller)
  }

  public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.controllerDidChangeContent?(controller)
  }

  public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                         sectionIndexTitleForSectionName sectionName: String) -> String? {
    return delegate?.controller?(controller, sectionIndexTitleForSectionName: sectionName)
  }

  //----------------------------------------------------------------------------
  // MARK: - Mutable Copying
  //----------------------------------------------------------------------------

  public func mutableCopy(with zone: NSZone? = nil) -> Any {
    let copy = FetchedResults()
    copy.request = request
    copy.context = context
    copy.sectionNameKeyPath = sectionNameKeyPath
    copy.cacheName = cacheName
    return copy
  }

}
