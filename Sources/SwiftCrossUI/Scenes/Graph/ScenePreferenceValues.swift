import Foundation

public struct ScenePreferenceValues: Sendable {
    public static let `default` = ScenePreferenceValues(
        commands: .empty
    )

    public var commands: Commands

    init(commands: Commands) {
        self.commands = commands
    }

    init(merging children: [ScenePreferenceValues]) {
        commands = children.map(\.commands).reduce(.empty) { $0.overlayed(with: $1) }
    }
}
