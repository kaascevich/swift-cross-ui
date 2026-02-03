struct StateImpl<Storage: StateStorageProtocol> {
    /// The inner `Storage` is what stays constant between view updates.
    /// The wrapping box is used so that we can assign the storage to future
    /// state instances from the non-mutating ``update(with:previousValue:)``
    /// method. It's vital that the inner storage remains the same so that
    /// bindings can be stored across view updates.
    var box: Box<Storage>

    var storage: Storage {
        get { box.value }
        nonmutating set { box.value = newValue }
    }

    init(initialStorage: Storage) {
        self.box = Box(initialStorage)
    }

    init(initialStorage: Storage) where Storage.Value: ObservableObject {
        self.box = Box(initialStorage)
        storage.downstreamObservation = storage.didChange.link(
            toUpstream: initialStorage.value.didChange
        )
    }

    init(initialStorage: Storage) where Storage.Value: OptionalObservableObject {
        self.box = Box(initialStorage)
        if let innerDidChange = initialStorage.value.didChange {
            // If we have an `Optional<some ObservableObject>.some`, then observe its
            // inner value's publisher.
            storage.downstreamObservation = storage.didChange.link(toUpstream: innerDidChange)
        }
    }

    var wrappedValue: Storage.Value {
        get { storage.value }
        nonmutating set {
            storage.value = newValue
            storage.postSet()
        }
    }

    var projectedValue: Binding<Storage.Value> {
        // Specifically link the binding to the inner storage instead of the
        // outer box which changes with each view update.
        let storage = storage
        return Binding(
            get: { storage.value },
            set: { newValue in
                storage.value = newValue
                storage.postSet()
            }
        )
    }

    func update(with environment: EnvironmentValues, previousValue: Self?) {
        if let previousValue {
            storage = previousValue.storage
        }
    }
}

protocol StateStorageProtocol: AnyObject {
    associatedtype Value
    var value: Value { get set }
    var didChange: Publisher { get }
    var downstreamObservation: Cancellable? { get set }
}

extension StateStorageProtocol {
    /// Call this to publish an observation to all observers after
    /// setting a new value. This isn't in a `didSet` property accessor
    /// because we want more granular control over when it does and
    /// doesn't trigger.
    func postSet() {
        didChange.send()
    }

    /// Call this to publish an observation to all observers after
    /// setting a new value. This isn't in a `didSet` property accessor
    /// because we want more granular control over when it does and
    /// doesn't trigger.
    ///
    /// This overload operates on `Optional<some ObservableObject>`; it
    /// updates the downstream observation if the wrapped value's current
    /// case has toggled.
    func postSet() where Value: OptionalObservableObject {
        // If the wrapped value is an `Optional<some ObservableObject>`
        // then we need to observe/unobserve whenever the optional
        // toggles between `.some` and `.none`.
        if let innerDidChange = value.didChange, downstreamObservation == nil {
            downstreamObservation = didChange.link(toUpstream: innerDidChange)
        } else if value.didChange == nil, let observation = downstreamObservation {
            observation.cancel()
            downstreamObservation = nil
        }
        didChange.send()
    }
}
