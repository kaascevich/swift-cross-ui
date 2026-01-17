import Foundation

/// The environment used when constructing scenes and views. Each scene or view
/// gets to modify the environment before passing it on to its children, which
/// is the basis of many view modifiers.
public struct EnvironmentValues {
    /// The current stack orientation. Inherited by ``ForEach`` and ``Group`` so
    /// that they can be used without affecting layout.
    public var layoutOrientation = Orientation.vertical
    /// The current stack alignment. Inherited by ``ForEach`` and ``Group`` so
    /// that they can be used without affecting layout.
    public var layoutAlignment = StackAlignment.center
    /// The current stack spacing. Inherited by ``ForEach`` and ``Group`` so
    /// that they can be used without affecting layout.
    public var layoutSpacing = 10

    /// A font resolution context derived from the current environment.
    ///
    /// Essentially just a subset of the environment.
    @MainActor
    public var fontResolutionContext: Font.Context {
        Font.Context(
            overlay: fontOverlay,
            deviceClass: backend.deviceClass,
            resolveTextStyle: { backend.resolveTextStyle($0) }
        )
    }

    /// The current font resolved to a form suitable for rendering. Just a
    /// helper method for our own backends. We haven't made this public because
    /// it would be weird to have two pretty equivalent ways of resolving fonts.
    @MainActor
    package var resolvedFont: Font.Resolved {
        font.resolve(in: fontResolutionContext)
    }

    /// The suggested foreground color for backends to use. Backends don't
    /// neccessarily have to obey this when ``Environment/foregroundColor``
    /// is `nil`.
    public var suggestedForegroundColor: Color {
        foregroundColor ?? colorScheme.defaultForegroundColor
    }

    /// The scale factor of the current window.
    public var windowScaleFactor: Double = 1.0

    /// Called by view graph nodes when they resize due to an internal state
    /// change and end up changing size. Each view graph node sets its own
    /// handler when passing the environment on to its children, setting up
    /// a bottom-up update chain up which resize events can propagate.
    var onResize: @MainActor (_ newSize: ViewSize) -> Void = { _ in }

    /// The app storage provider to use for `@AppStorage` property wrappers.
    public let appStorageProvider: any AppStorageProvider

    /// An internal environment value used to control whether layout caching is
    /// enabled or not. This is set to true when computing non-final layouts. E.g.
    /// when a stack computes the minimum and maximum sizes of its children, it
    /// should enable layout caching because those updates are guaranteed to be
    /// non-final. The reason that we can't cache on non-final updates is that
    /// the last layout proposal received by each view must be its intended final
    /// proposal.
    var allowLayoutCaching = false

    /// Brings the current window forward, not guaranteed to always bring
    /// the window to the top (due to focus stealing prevention).
    @MainActor
    func bringWindowForward() {
        func activate<Backend: AppBackend>(with backend: Backend) {
            backend.activate(window: window as! Backend.Window)
        }
        activate(with: backend)
    }

    /// The backend's representation of the window that the current view is
    /// in, if any. This is a very internal detail that should never get
    /// exposed to users.
    package var window: Any?
    /// The backend's representation of the sheet that the current view is
    /// in, if any. This is a very internal detail that should never get
    /// exposed to users.
    package var sheet: Any?
    /// The backend in use. Mustn't change throughout the app's lifecycle.
    let backend: any AppBackend

    /// The current calendar that views should use when handling dates.
    public var calendar = Calendar.current

    /// The current time zone that views should use when handling dates.
    public var timeZone = TimeZone.current

    /// The display styles supported by ``DatePicker``. ``datePickerStyle`` must be one of these.
    public let supportedDatePickerStyles: [DatePickerStyle]

    /// Backing storage for extensible subscript
    private var extraValues: [ObjectIdentifier: Any] = [:]

    public subscript<T: EnvironmentKey>(_ key: T.Type) -> T.Value {
        get {
            extraValues[ObjectIdentifier(T.self), default: T.defaultValue] as! T.Value
        }
        set {
            extraValues[ObjectIdentifier(T.self)] = newValue
        }
    }

    /// Creates the default environment.
    package init<Backend: AppBackend>(
        backend: Backend,
        appStorageProvider: any AppStorageProvider = DefaultAppStorageProvider()
    ) {
        self.backend = backend
        self.appStorageProvider = appStorageProvider
        
        self.supportedDatePickerStyles = if backend.supportedDatePickerStyles.isEmpty {
            [.automatic]
        } else {
            backend.supportedDatePickerStyles
        }
    }

    /// Returns a copy of the environment with the specified property set to the
    /// provided new value.
    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ newValue: T) -> Self {
        var environment = self
        environment[keyPath: keyPath] = newValue
        return environment
    }
}

/// A key that can be used to extend the environment with new properties.
public protocol EnvironmentKey<Value> {
    /// The type of value the key can hold.
    associatedtype Value
    /// The default value for the key.
    static var defaultValue: Value { get }
}
