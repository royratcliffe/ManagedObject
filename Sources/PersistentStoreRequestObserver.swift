// ManagedObject PersistentStoreRequestObserver.swift
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

/// Observes persistent-store requests by implementing the incremental store
/// abstract class. The request observer dispatches notifications for all
/// persistent store requests arriving within a context. Posts notifications
/// using the default notification centre, passing the fetch or save
/// request. Useful for observing requests and triggering asynchronous responses
/// to specific request types.
///
/// The class sub-classes from the incremental store abstraction but does not
/// implement all but the very necessary abstract methods. This is the minimal
/// incremental store. It does no storing; just observes what goes on within a
/// context.
public class PersistentStoreRequestObserver: NSIncrementalStore {

  public static let Notification = "PersistentStoreRequestNotification"

  public static let FetchKey = "FetchRequest"

  public static let SaveKey = "SaveRequest"

  /// - returns: the store type for the observer class. It corresponds to the
  ///   class name.
  public class var storeType: String {
    return NSStringFromClass(self)
  }

  public override class func initialize() {
    guard PersistentStoreRequestObserver.self === self else { return }
    NSPersistentStoreCoordinator.registerStoreClass(self, forStoreType: storeType)
  }

  //----------------------------------------------------------------------------
  // MARK: - Incremental Store
  //----------------------------------------------------------------------------

  /// Does nothing, but needs an empty implementation in order to add the store
  /// to a coordinator. Fails without an implementation.
  public override func loadMetadata() throws {}

  /// Runs whenever the application makes a Core Data context request. Arrives
  /// here *before* the request completes, returning back up the call stack
  /// aftwards. This includes performing a fetch using a fetched results
  /// controller, i.e. the request executes here within the caller's stack an
  /// subsequently returns to the controller.
  public override func execute(_ request: NSPersistentStoreRequest,
                               with context: NSManagedObjectContext?) throws -> AnyObject {
    var userInfo = [NSObject: AnyObject]()
    switch request.requestType {
    case .fetchRequestType:
      guard let fetchRequest = request as? NSFetchRequest<NSManagedObject> else { break }
      userInfo[PersistentStoreRequestObserver.FetchKey] = fetchRequest
    case .saveRequestType:
      guard let saveRequest = request as? NSSaveChangesRequest else { break }
      userInfo[PersistentStoreRequestObserver.SaveKey] = saveRequest
    default:
      break
    }
    if !userInfo.isEmpty {
      let center = NotificationCenter.default
      let name = Foundation.Notification.Name(rawValue: PersistentStoreRequestObserver.Notification)
      center.post(name: name, object: self, userInfo: userInfo)
    }

    return []
  }

}
