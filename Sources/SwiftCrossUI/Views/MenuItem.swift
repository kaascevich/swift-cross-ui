/// An item of a ``Menu`` or ``CommandMenu``.
public enum MenuItem: Sendable {
    /// A button.
    case button(Button)
    /// Text.
    case text(Text)
    /// A toggle.
    case toggle(Toggle)
    /// A separator.
    case separator(Divider)
    /// A submenu.
    case submenu(Menu)

    /// A menu item with an environment modifier.
    indirect case modifiedEnvironment(
        MenuItem,
        @Sendable (EnvironmentValues) -> EnvironmentValues
    )
}

// MARK: Views that can be used as menu items

protocol MenuItemRepresentable: View {
    var asMenuItem: MenuItem { get }
}

extension Button: MenuItemRepresentable {
    var asMenuItem: MenuItem { .button(self) }
}

extension Text: MenuItemRepresentable {
    var asMenuItem: MenuItem { .text(self) }
}

extension Toggle: @MainActor MenuItemRepresentable {
    var asMenuItem: MenuItem { .toggle(self) }
}

extension Divider: @MainActor MenuItemRepresentable {
    var asMenuItem: MenuItem { .separator(self) }
}

extension Menu: MenuItemRepresentable {
    var asMenuItem: MenuItem { .submenu(self) }
}

extension TupleView1: MenuItemRepresentable where View0: MenuItemRepresentable {
    var asMenuItem: MenuItem { view0.asMenuItem }
}

extension EnvironmentModifier: @MainActor MenuItemRepresentable where Child: MenuItemRepresentable {
    var asMenuItem: MenuItem {
        .modifiedEnvironment(self.body.asMenuItem, self.modification)
    }
}
