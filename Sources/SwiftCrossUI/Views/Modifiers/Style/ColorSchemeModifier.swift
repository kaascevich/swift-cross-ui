extension View {
    public func colorScheme(_ colorScheme: ColorScheme) -> some View {
        environment(\.colorScheme, colorScheme)
    }
}

private enum ColorSchemeKey: EnvironmentKey {
    static var defaultValue: ColorScheme {
        .light
    }
}

extension EnvironmentValues {
    /// The current color scheme of the current view scope.
    public var colorScheme: ColorScheme {
        get { self[ColorSchemeKey.self] }
        set { self[ColorSchemeKey.self] = newValue }
    }
}
