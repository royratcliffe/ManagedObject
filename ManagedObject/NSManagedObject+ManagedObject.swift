// ManagedObject NSManagedObject+ManagedObject.swift
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

extension NSManagedObject {

  /// - returns: Entity name for the managed-object sub-class. Bases the entity
  ///   name on the object's class name. Ignores the module name if the class
  ///   name includes a module.
  public class var entityName: String {
    let className = NSStringFromClass(object_getClass(self))
    let components = className.componentsSeparatedByString(".")
    return components.last ?? className
  }

  /// Initialises and inserts a new managed object into the given managed-object
  /// context. Fails if the given context's data model does not contain an
  /// entity description with a matching entity name.
  public convenience init?(context: NSManagedObjectContext) {
    let entityName = self.dynamicType.entityName
    guard let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context) else {
      return nil
    }
    self.init(entity: entity, insertIntoManagedObjectContext: context)
  }

  /// Performs a block within this object's managed-object context queue,
  /// assuming that this managed object knows its context; otherwise does
  /// nothing. Just a convenience method.
  public func performBlock(block: () -> Void) {
    managedObjectContext?.performBlock(block)
  }

  /// Performs a block within this object's context and waits for completion.
  public func performBlockAndWait(block: () -> Void) {
    managedObjectContext?.performBlockAndWait(block)
  }

}
