// ManagedObject Stack.swift
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

/// Lazily sets up a master-main-worker Core Data stack: one master context, one
/// main context and arrange for multiple children used by private-queue
/// workers.
///
/// Adds an in-memory store with an "InMemory" configuration by default. Adding
/// a in-memory store can logically fail, even if never in practice. Coordinator
/// construction catches any error and logs it but nothing more.
public struct Stack {

  public init() {}

  public lazy var managedObjectModel: NSManagedObjectModel = {
    return NSManagedObjectModel.mergedModelFromBundles(nil)!
  }()

  public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    do {
      try coordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: "InMemory", URL: nil, options: nil)
    }
    catch {
      NSLog("%@", error as NSError)
    }
    return coordinator
  }()

  public lazy var masterContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    context.persistentStoreCoordinator = self.persistentStoreCoordinator
    return context
  }()

  /// - returns: a main-queue managed-object context for use in the main
  ///   dispatch queue, including the user interface. The main context is a
  ///   master-context child.
  public lazy var mainContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.parentContext = self.masterContext
    return context
  }()

  /// - returns: a new main-context child with private-queue concurrency that
  ///   can be used to make changes that asynchronous workers can subsequently
  ///   either save to pass the changes back to the main context, or discard
  ///   without changing the main context.
  public mutating func newWorkerContext() -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    context.parentContext = self.mainContext
    return context
  }

}
