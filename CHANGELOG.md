# Change Log

## [0.2.0](https://github.com/royratcliffe/managedobject/tree/0.2.0) (2016-08-13)

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
