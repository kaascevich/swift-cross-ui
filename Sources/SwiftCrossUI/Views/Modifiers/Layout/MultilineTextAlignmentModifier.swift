extension View {
    /// Sets the alignment of lines of text relative to each other in multiline
    /// text views.
    public func multilineTextAlignment(_ alignment: HorizontalAlignment) -> some View {
        environment(\.multilineTextAlignment, alignment)
    }
}

private enum MultilineTextAlignmentKey: EnvironmentKey {
    static var defaultValue: HorizontalAlignment {
        .leading
    }
}

extension EnvironmentValues {
    /// How lines should be aligned relative to each other when line wrapped.
    public var multilineTextAlignment: HorizontalAlignment {
        get { self[MultilineTextAlignmentKey.self] }
        set { self[MultilineTextAlignmentKey.self] = newValue }
    }
}
