/// The active state of a scene or app.
public enum ScenePhase: Hashable, Sendable {
    /// The scene is active.
    case active
    /// The scene is inactive.
    case inactive

    // TODO: Figure out how .background would work on desktops
}
