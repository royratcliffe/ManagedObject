// ManagedObject NotificationCenter+ManagedObject.swift
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

extension NotificationCenter {

  /// Adds an objects-did-change observer block to the notification
  /// centre. Invokes a block using a ObjectsDidChange structure which
  /// encapsulates the notification's managed-object context and user
  /// information. Ignores change notifications with missing contexts or
  /// information dictionaries.
  /// - parameter context: Managed-object context to observe, or `nil` for all
  ///   contexts.
  /// - parameter queue: Operation queue on which to execute the block, or `nil`
  ///   to run the block synchronously on the notification's posting thread.
  /// - parameter block: Block executed when objects did change.
  /// - parameter objectsDidChange: Wrapper for notification's context and user
  ///   information.
  /// - returns: Opaque object used to remove the observer.
  public func addObjectsDidChangeObserver(context: NSManagedObjectContext?,
                                          queue: OperationQueue? = nil,
                                          using block: @escaping (_ objectsDidChange: ObjectsDidChange) -> Void) -> NSObjectProtocol {
    let name = Notification.Name.NSManagedObjectContextObjectsDidChange
    return addObserver(forName: name, object: context, queue: queue) { (notification) in
      if let objectsDidChange = ObjectsDidChange(notification: notification) {
        block(objectsDidChange)
      }
    }
  }

}
