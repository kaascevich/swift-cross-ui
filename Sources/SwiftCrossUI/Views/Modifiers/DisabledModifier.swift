extension View {
    /// Disables user interaction in any subviews that support disabling
    /// interaction.
    public func disabled(_ disabled: Bool = true) -> some View {
        environment(\.isEnabled, !disabled)
    }
}

private enum IsEnabledKey: EnvironmentKey {
    static var defaultValue: Bool {
        true
    }
}

extension EnvironmentValues {
    /// Whether user interaction is enabled. Set by ``View/disabled(_:)``.
    public var isEnabled: Bool {
        get { self[IsEnabledKey.self] }
        set { self[IsEnabledKey.self] = newValue }
    }
}
