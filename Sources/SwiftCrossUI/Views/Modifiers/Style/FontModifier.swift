extension View {
    /// Sets the font of contained text. Can be overridden by other font
    /// modifiers within the contained view, unlike other font-related
    /// modifiers such as ``View/fontWeight(_:)`` and ``View/emphasized()``
    /// which override the font properties of all contained text.
    public func font(_ font: Font) -> some View {
        environment(\.font, font)
    }

    /// Overrides the font weight of any contained text. Optional for
    /// convenience. If given `nil`, does nothing.
    public func fontWeight(_ weight: Font.Weight?) -> some View {
        environment(\.fontOverlay.weight, weight)
    }

    /// Overrides the font design of any contained text. Optional for
    /// convenience. If given `nil`, does nothing.
    public func fontDesign(_ design: Font.Design?) -> some View {
        environment(\.fontOverlay.design, design)
    }

    /// Forces any contained text to be bold, or if the a contained font is
    /// a ``Font/TextStyle``, forces the style's emphasized weight to be
    /// used.
    ///
    /// Deprecated and renamed for clarity. Use ``View.fontWeight(_:)``
    /// to make text bold.
    @available(
        *, deprecated,
        message: "Use View.emphasized() instead",
        renamed: "View.emphasized()"
    )
    public func bold() -> some View {
        emphasized()
    }

    /// Forces any contained text to become emphasized. For text that uses
    /// ``Font/TextStyle``-based fonts, this means using the text style's
    /// emphasized weight. For all other text, this means using
    /// ``Font/Weight/bold``.
    public func emphasized() -> some View {
        environment(\.fontOverlay.emphasize, true)
    }

    /// Forces any contained text to become italic.
    public func italic() -> some View {
        environment(\.fontOverlay.italicize, true)
    }
}

private enum FontKey: EnvironmentKey {
    static var defaultValue: Font {
        .body
    }
}

private enum FontOverlayKey: EnvironmentKey {
    static var defaultValue: Font.Overlay {
        Font.Overlay()
    }
}

extension EnvironmentValues {
    /// The current font.
    public var font: Font {
        get { self[FontKey.self] }
        set { self[FontKey.self] = newValue }
    }

    /// A font overlay storing font modifications. If these conflict with the
    /// font's internal overlay, these win.
    ///
    /// We keep this separate overlay for modifiers because we want modifiers to
    /// be persisted even if the developer sets a custom font further down the
    /// view hierarchy.
    var fontOverlay: Font.Overlay {
        get { self[FontOverlayKey.self] }
        set { self[FontOverlayKey.self] = newValue }
    }
}
