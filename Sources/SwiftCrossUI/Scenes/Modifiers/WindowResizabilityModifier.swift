extension Scene {
    /// Sets the resizability of windows controlled by this scene.
    ///
    /// This modifier controls how SwiftCrossUI determines the bounds within which
    /// windows can be resized, whereas ``View/windowResizeBehavior(_:)`` controls
    /// whether the user can resize the enclosing window. The only time this
    /// modifier can disable interactive resizing is when a window's content has
    /// a fixed size and `resizability` is ``WindowResizability/contentSize``.
    public func windowResizability(_ resizability: WindowResizability) -> some Scene {
        environment(\.windowResizability, resizability)
    }
}

private enum WindowResizabilityKey: EnvironmentKey {
    static var defaultValue: WindowResizability {
        .automatic
    }
}

extension EnvironmentValues {
    /// The resizing behaviour of the current window.
    var windowResizability: WindowResizability {
        get { self[WindowResizabilityKey.self] }
        set { self[WindowResizabilityKey.self] = newValue }
    }
}

