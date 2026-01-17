extension View {
    /// Sets the style of the toggle.
    public func toggleStyle(_ toggleStyle: ToggleStyle) -> some View {
        environment(\.toggleStyle, toggleStyle)
    }
}

private enum ToggleStyleKey: EnvironmentKey {
    static var defaultValue: ToggleStyle {
        .button
    }
}

extension EnvironmentValues {
    /// The style of toggle to use.
    public var toggleStyle: ToggleStyle {
        get { self[ToggleStyleKey.self] }
        set { self[ToggleStyleKey.self] = newValue }
    }
}
