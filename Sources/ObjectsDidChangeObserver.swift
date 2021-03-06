// ManagedObject ObjectsDidChangeObserver.swift
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

import CoreData

/// Observes managed-object changes, collates those changes and notifies change
/// controllers; automatically instantiates such change controllers if required.
///
/// Set up the observer by adding it to the notification centre. Then add change
/// controllers, one for each entity that might change. The observer invokes the
/// controllers when one or more objects of interest change: either inserted,
/// updated or deleted. When inserting objects, a change controller receives a
/// `insertedObjects(objects: [NSManagedObject])` method invocation where the
/// argument is an array of managed objects for insertion. Similarly for updated
/// and deleted.
public class ObjectsDidChangeObserver: NSObject {

  /// True if you want the observer to use the Objective-C run-time to
  /// automatically instantiate change controllers based on entity name. Looks
  /// for entity name plus `ChangeController` as an Objective-C class name. This
  /// is not the default behaviour because change controllers will typically
  /// require additional set-up beyond just simple instantiation before they
  /// are ready to begin observing changes.
  public var automaticallyInstantiatesChangeControllers = false

  /// Handles a managed-object change notification. Instantiates change
  /// controllers automatically if the Objective-C run-time environment has a
  /// controller class matching the entity name plus `ChangeController`.
  @objc private func objectsDidChange(_ notification: Notification) {
    guard NSNotification.Name.NSManagedObjectContextObjectsDidChange == notification.name else { return }
    guard let objectsDidChange = ObjectsDidChange(notification: notification) else { return }

    // Iterate change keys and entity names. The change key becomes part of the
    // selector. The entity name becomes part of the controller class name.
    for (changeKey, objectsByEntityName) in objectsDidChange.managedObjectsByEntityNameByChangeKey {
      let selector = Selector("\(changeKey)Objects:")
      for (entityName, objects) in objectsByEntityName {
        var changeController = changeControllersByEntityName[entityName]
        if automaticallyInstantiatesChangeControllers && changeController == nil {
          let changeControllerClassName = "\(entityName)ChangeController"
          if let changeControllerClass = NSClassFromString(changeControllerClassName) as? NSObject.Type {
            changeController = changeControllerClass.init()
            changeControllersByEntityName[entityName] = changeController
          }
        }
        if let controller = changeController {
          if controller.responds(to: selector) {
            controller.perform(selector, with: objects)
          }
        }
      }
    }
  }

  //----------------------------------------------------------------------------
  // MARK: - Change Controllers

  var changeControllersByEntityName = [String: NSObject]()

  /// Adds a change controller for the given entity name. There can be only one
  /// controller for each entity. If your application requires more than one
  /// controller, use more than one observer.
  public func add(changeController: NSObject, forEntityName entityName: String) {
    changeControllersByEntityName[entityName] = changeController
  }

  /// Removes a change controller.
  public func removeChangeController(forEntityName entityName: String) {
    changeControllersByEntityName.removeValue(forKey: entityName)
  }

  //----------------------------------------------------------------------------
  // MARK: - Notification Centre

  /// Adds this observer to the given notification centre.
  public func add(to center: NotificationCenter, context: NSManagedObjectContext? = nil) {
    center.addObserver(self,
      selector: #selector(ObjectsDidChangeObserver.objectsDidChange(_:)),
      name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
      object: context)
  }

  /// Removes this observer from the given notification centre.
  public func remove(from center: NotificationCenter) {
    center.removeObserver(self)
  }

}
