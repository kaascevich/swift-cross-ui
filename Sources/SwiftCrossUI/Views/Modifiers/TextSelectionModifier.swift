extension View {
    /// Sets selectability of contained text. Ignored on tvOS.
    public func textSelectionEnabled(_ isEnabled: Bool = true) -> some View {
        environment(\.isTextSelectionEnabled, isEnabled)
    }
}

private enum TextSelectionEnabledKey: EnvironmentKey {
    static var defaultValue: Bool {
        false
    }
}

extension EnvironmentValues {
    /// Whether the text should be selectable. Set by ``View/textSelectionEnabled(_:)``.
    public var isTextSelectionEnabled: Bool {
        get { self[TextSelectionEnabledKey.self] }
        set { self[TextSelectionEnabledKey.self] = newValue }
    }
}
