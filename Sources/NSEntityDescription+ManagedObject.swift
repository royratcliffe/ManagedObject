// ManagedObject NSEntityDescription+ManagedObject.swift
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

extension NSEntityDescription {

  /// Returns a new fetch request for this entity. Returns `nil` if the entity
  /// description has no name.
  public func fetchRequest<Result: NSFetchRequestResult>() -> NSFetchRequest<Result>? {
    guard let name = name else { return nil }
    return NSFetchRequest<Result>(entityName: name)
  }

  /// Returns new fetch request with given predicate; `nil` for nameless entity.
  public func fetchRequest<Result: NSFetchRequestResult>(where predicate: NSPredicate) -> NSFetchRequest<Result>? {
    guard let request: NSFetchRequest<Result> = fetchRequest() else { return nil }
    request.predicate = predicate
    return request
  }

  // MARK: - Fetch

  /// Fetches the first result.
  public func fetchFirst<Result: NSFetchRequestResult>(in context: NSManagedObjectContext) throws -> Result? {
    guard let request: NSFetchRequest<Result> = fetchRequest() else { return nil }
    request.fetchLimit = 1
    return try context.fetch(request).first
  }

  /// Fetches all results matching the given predicate.
  public func fetchAll<Result: NSFetchRequestResult>(where predicate: NSPredicate, in context: NSManagedObjectContext) throws -> [Result] {
    guard let request: NSFetchRequest<Result> = fetchRequest(where: predicate) else { return [] }
    return try context.fetch(request)
  }

  /// Fetches the first result matching the given predicate.
  public func fetchFirst<Result: NSFetchRequestResult>(where predicate: NSPredicate, in context: NSManagedObjectContext) throws -> Result? {
    guard let request: NSFetchRequest<Result> = fetchRequest(where: predicate) else { return nil }
    request.fetchLimit = 1
    return try context.fetch(request).first
  }

}
