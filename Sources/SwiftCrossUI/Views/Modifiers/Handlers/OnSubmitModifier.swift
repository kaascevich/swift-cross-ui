extension View {
    /// Adds an action to perform when the user submits a text field within this
    /// view (generally via pressing the Enter/Return key). Outer `onSubmit`
    /// handlers get called before inner `onSubmit` handlers. To prevent
    /// submissions from propagating upwards, use ``View/submitScope()`` after
    /// adding the handler.
    public func onSubmit(perform action: @escaping () -> Void) -> some View {
        EnvironmentModifier(self) { environment in
            environment.with(\.onSubmit) {
                environment.onSubmit?()
                action()
            }
        }
    }

    /// Prevents text field submissions from propagating to this view's
    /// ancestors.
    public func submitScope() -> some View {
        environment(\.onSubmit, nil)
    }
}

private enum OnSubmitKey: EnvironmentKey {
    static var defaultValue: (@MainActor () -> Void)? {
        nil
    }
}

extension EnvironmentValues {
    /// Called when a text field gets submitted (usually due to the user
    /// pressing Enter/Return).
    public var onSubmit: (@MainActor () -> Void)? {
        get { self[OnSubmitKey.self] }
        set { self[OnSubmitKey.self] = newValue }
    }
}
