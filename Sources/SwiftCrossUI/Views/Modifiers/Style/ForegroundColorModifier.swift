extension View {
    /// Sets the color of the foreground elements displayed by this view.
    public func foregroundColor(_ color: Color) -> some View {
        environment(\.foregroundColor, color)
    }
}

private enum ForegroundColorKey: EnvironmentKey {
    static var defaultValue: Color? {
        nil
    }
}

extension EnvironmentValues {
    /// The foreground color. `nil` means that the default foreground color of
    /// the current color scheme should be used.
    public var foregroundColor: Color? {
        get { self[ForegroundColorKey.self] }
        set { self[ForegroundColorKey.self] = newValue }
    }
}
