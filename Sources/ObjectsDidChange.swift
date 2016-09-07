// ManagedObject ObjectsDidChange.swift
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

/// Wraps an objects-did-change notification's context and user information.
public struct ObjectsDidChange {

  public let context: NSManagedObjectContext

  let userInfo: [AnyHashable: Any]

  /// Answers `nil` if the notification object is not a managed-object context,
  /// or if the notification's user information does not exist. User information
  /// should always be a dictionary.
  init?(notification: Notification) {
    guard let context = notification.object as? NSManagedObjectContext else { return nil }
    guard let userInfo = notification.userInfo else { return nil }
    self.context = context
    self.userInfo = userInfo
  }

  public func objects(_ key: String) -> NSSet? {
    return userInfo[key] as? NSSet
  }

  public func managedObjects(_ key: String) -> [NSManagedObject]? {
    return objects(key)?.flatMap { $0 as? NSManagedObject }
  }

  public func manageObjectIDs(_ key: String) -> [NSManagedObjectID]? {
    return managedObjects(key)?.map { $0.objectID }
  }

  public var insertedObjects: NSSet? {
    return objects(NSInsertedObjectsKey)
  }

  public var updatedObjects: NSSet? {
    return objects(NSUpdatedObjectsKey)
  }

  public var deletedObjects: NSSet? {
    return objects(NSDeletedObjectsKey)
  }

  public var refreshedObjects: NSSet? {
    return objects(NSRefreshedObjectsKey)
  }

  public var invalidatedObjects: NSSet? {
    return objects(NSInvalidatedObjectsKey)
  }

  /// Identifies which if any keys apply to the given managed-object identifier.
  /// - parameter objectID: Managed-object identifier to search for.
  /// - returns: Array of zero-or-more string keys, one for each set of objects
  ///   the given identifier is a member of.
  public func keys(for objectID: NSManagedObjectID) -> [String] {
    var keys = [String]()
    for key in ObjectsDidChange.keys {
      if let objectIDs = manageObjectIDs(key), objectIDs.contains(objectID) {
        keys.append(key)
      }
    }
    return keys
  }

  public func keys(for object: NSManagedObject) -> [String] {
    return keys(for: object.objectID)
  }

  public static let keys = [
    NSInsertedObjectsKey,
    NSUpdatedObjectsKey,
    NSDeletedObjectsKey,
    NSRefreshedObjectsKey,
    NSInvalidatedObjectsKey
  ]

}