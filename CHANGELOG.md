# Change Log

## [0.10.0](https://github.com/royratcliffe/managedobject/tree/0.10.0) (2016-11-03)

- Added entity-description helpers
- Name the master, main and worker contexts; useful for debugging

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.9.1...0.10.0)

## [0.9.1](https://github.com/royratcliffe/managedobject/tree/0.9.1) (2016-10-31)

- Re-installed guard condition for objects-did-change notification name
- `ObjectsDidChange` wraps merge-changes notifications also

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.9.0...0.9.1)

## [0.9.0](https://github.com/royratcliffe/managedobject/tree/0.9.0) (2016-10-28)

- `ObjectsDidChange` implements custom debug string convertible protocol
- Refactored `managedObjectsByEntityNameByChangeKey `
- Check for correct notification name in `ObjectsDidChange` initialiser
- Fixed typo; managed not manage
- Extensions for `NSFetchRequest`
- Copying fetched results copies fetch request, if any
- Public access to set-up and tear-down controller for fetched results
- Objects-did-change observer can specify a `context` argument
- Xcode 8.1 updates project: additional warnings; no framework code signing
- Fix for initial objects by entity name by change key
- Fetch results has public `controller` getter
- `FetchResults.request(objectID:)` inherits sort descriptors
- `FetchedResults.request(for:)` answers request without sort descriptors
- `FetchedResults` adds methods `object(at:)` and `indexPath(forObject:)`

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.8.0...0.9.0)

## [0.8.0](https://github.com/royratcliffe/managedobject/tree/0.8.0) (2016-10-13)

- SwiftLint warning fix: long lines
- FIX: `fetchAll<Entity>` never answers `nil` instead of array
- Added `FetchResults` wrapper

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.7.1...0.8.0)

## [0.7.1](https://github.com/royratcliffe/managedobject/tree/0.7.1) (2016-10-06)

- Auto-merging changes merges within context's queue

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.7.0...0.7.1)

## [0.7.0](https://github.com/royratcliffe/managedobject/tree/0.7.0) (2016-09-08)

- Fixes @escaping may only be applied to parameters of function type (Xcode 8 GM)

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.6.0...0.7.0)

## [0.6.0](https://github.com/royratcliffe/managedobject/tree/0.6.0) (2016-09-07)

- Convenience method for instantiating new fetched-result controller
- FIX: insert new object by entity type

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.5.0...0.6.0)

## [0.5.0](https://github.com/royratcliffe/managedobject/tree/0.5.0) (2016-09-06)

- Type alias for escaping should-merge-changes block
- Added ObjectsDidChangeBlock type-alias
- ObjectsDidChange notification helpers

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.4.0...0.5.0)

## [0.4.0](https://github.com/royratcliffe/managedobject/tree/0.4.0) (2016-09-02)

- Context methods: 
    - `automaticallyMergesChangesFromChildren(queue:)` and 
    - `automaticallyMergesChanges(queue:shouldMergeChanges:)`

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.3.0...0.4.0)

## [0.3.0](https://github.com/royratcliffe/managedobject/tree/0.3.0) (2016-09-01)

- Managed-object context method: `automaticallyUpdatesTimestamps`
- Public access to `automaticallyMergesChanges`

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.2.3...0.3.0)

## [0.2.3](https://github.com/royratcliffe/managedobject/tree/0.2.3) (2016-08-30)

- Context insertNewObject by entity type
- Added managed-object context's automaticallyMergesChanges(from:queue:)
- Added NSManagedObjectContext.parents with tests
- Notification name for PersistentStoreRequestNotification

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.2.2...0.2.3)

## [0.2.2](https://github.com/royratcliffe/managedobject/tree/0.2.2) (2016-08-18)

- Use `Any` rather than `AnyObject`

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.2.1...0.2.2)

## [0.2.1](https://github.com/royratcliffe/managedobject/tree/0.2.1) (2016-08-18)

- `Any` instead of `AnyObject`, `String` cast to `NSString`
- Mark escaping blocks
- `type(of:)` replaces `dynamicType`

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.2.0...0.2.1)

## [0.2.0](https://github.com/royratcliffe/managedobject/tree/0.2.0) (2016-08-13)

- Renamed sub-folders to Sources and Tests
- Added Travis configuration
- Merge branch 'feature/swift_3_0' into develop
- Restore NS prefix for comparison predicate

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.1.7...0.2.0)

## [0.1.7](https://github.com/royratcliffe/managedobject/tree/0.1.7) (2016-08-11)

- Merge branch 'feature/swift_2_3' into develop
- Conditional initialiser "with context" for NSManagedObject
- Using Xcode 8, Swift 2.3
- Fetch first managed object(s) by entity type
- Comment about return value for fetchAll(entityType)

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.1.6...0.1.7)

## [0.1.6](https://github.com/royratcliffe/managedobject/tree/0.1.6) (2016-05-31)

- Context implements fetchAll(entityType)
- Renamed context fetch(entityName) to fetchAll(entityName)
- Removed unnecessary call to object_getClass()
- Added context's fetchFirst(entityName, fetchLimit=1) method
- NSManagedObject extensions: entityName and init?(context)
- Build phase runs SwiftLint

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.1.5...0.1.6)

## [0.1.3](https://github.com/royratcliffe/managedobject/tree/0.1.3) (2016-03-22)

- Moved NSManagedObjectContext extensions from Snippets
- Added change log
- Added ObjectsDidChangeObserver class

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.1.2...0.1.3)

## [0.1.2](https://github.com/royratcliffe/managedobject/tree/0.1.2) (2016-03-20)

- Persistent-store request observer class

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.1.1...0.1.2)

## [0.1.1](https://github.com/royratcliffe/managedobject/tree/0.1.1) (2016-03-19)

- Basic lazy construction tests
- New worker contexts inaccessible, fixed
- Stack needs a public initialiser
- Set up for CocoaPods

[Full Change Log](https://github.com/royratcliffe/managedobject/compare/0.1.0...0.1.1)

## [0.1.0](https://github.com/royratcliffe/managedobject/tree/0.1.0) (2016-03-19)

Initial commit.
