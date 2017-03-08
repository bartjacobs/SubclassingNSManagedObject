### [Subclassing NSManagedObject](https://cocoacasts.com/subclassing-nsmanagedobject-core-data/)

#### Author: Bart Jacobs

Up until now, we've used `NSManagedObject` instances to represent and interact with records stored in the persistent store. This works fine, but the syntax is verbose, we lose autocompletion, and type safety is also an issue.

Remember from earlier in this series that the values of a managed object are accessed by invoking `value(forKey:)` and `setValue(_:forKey:)`.

```swift
record.value(forKey: "firstName")
record.setValue("Bart", forKey: "firstName")
```

Because `value(forKey:)` returns an object of type `Any?`, we need to cast the result to the type we expect, using optional binding.

```swift
if let name = record.value(forKey: "name") as? String {
    print(name)
}
```

While we could improve these examples by replacing string literals with constants, there is an even better approach, subclassing `NSManagedObject`.

**Read this article on [Cocoacasts](https://cocoacasts.com/subclassing-nsmanagedobject-core-data/)**.
