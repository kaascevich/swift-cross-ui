extension View {
    /// Set the content type of text fields.
    ///
    /// This controls autocomplete suggestions, and on mobile devices, which on-screen keyboard
    /// is shown.
    public func textContentType(_ type: TextContentType) -> some View {
        environment(\.textContentType, type)
    }
}

private enum TextContentTypeKey: EnvironmentKey {
    static var defaultValue: TextContentType {
        .text
    }
}

extension EnvironmentValues {
    /// The type of input that text fields represent.
    ///
    /// This affects autocomplete suggestions, and on devices with no physical keyboard, which
    /// on-screen keyboard to use.
    ///
    /// Do not use this in place of validation, even if you only plan on supporting mobile
    /// devices, as this does not restrict copy-paste and many mobile devices support bluetooth
    /// keyboards.
    public var textContentType: TextContentType {
        get { self[TextContentTypeKey.self] }
        set { self[TextContentTypeKey.self] = newValue }
    }
}
