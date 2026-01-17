package enum ListStyle {
    case `default`
    case sidebar
}

private enum ListStyleKey: EnvironmentKey {
    static var defaultValue: ListStyle {
        .default
    }
}

extension EnvironmentValues {
    /// The style of list to use.
    package var listStyle: ListStyle {
        get { self[ListStyleKey.self] }
        set { self[ListStyleKey.self] = newValue }
    }
}

