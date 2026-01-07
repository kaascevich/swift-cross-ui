/// An empty scene.
public struct EmptyScene: Scene {
    public typealias Node = EmptySceneNode

    /// The nonexistent body of an empty scene.
    ///
    /// - Warning: Don't access this directly; it will crash the app.
    public var body: Never { fatalError("cannot render Never") }
}

public final class EmptySceneNode: SceneGraphNode {
    public typealias NodeScene = EmptyScene

    public init<Backend: AppBackend>(
        from scene: NodeScene,
        backend: Backend,
        environment: EnvironmentValues
    ) {}

    public func update<Backend: AppBackend>(
        _ newScene: NodeScene?,
        backend: Backend,
        environment: EnvironmentValues
    ) -> SceneUpdateResult {
        SceneUpdateResult.leafScene()
    }
}

extension Never: Scene {
    public final class Node: SceneGraphNode {
        public init<Backend: AppBackend>(
            from scene: Never,
            backend: Backend,
            environment: EnvironmentValues
        ) {}

        public func update<Backend: AppBackend>(
            _ newScene: Never?,
            backend: Backend,
            environment: EnvironmentValues
        ) -> SceneUpdateResult {
            fatalError()
        }
    }
}
