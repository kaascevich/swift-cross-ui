extension View {
    /// Sets the menu sort order, for backends that support it.
    ///
    /// This is currently only respected by UIKitBackend, and only on iOS/tvOS
    /// 16 and up. On other backends, it always behaves as if set to ``MenuOrder/fixed``.
    public func menuOrder(_ order: MenuOrder) -> some View {
        environment(\.menuOrder, order)
    }
}

private enum MenuOrderKey: EnvironmentKey {
    static var defaultValue: MenuOrder { .automatic }
}

extension EnvironmentValues {
    /// The menu ordering to use.
    public var menuOrder: MenuOrder {
        get { self[MenuOrderKey.self] }
        set { self[MenuOrderKey.self] = newValue }
    }
}
