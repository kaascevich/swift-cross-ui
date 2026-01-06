import DummyBackend
import Testing

@testable import SwiftCrossUI

@MainActor
func computeLayoutForView(
    proposedSize: ProposedViewSize,
    _ view: () -> some View
) -> ViewLayoutResult {
    let backend = DummyBackend()
    let window = backend.createWindow(withDefaultSize: nil)

    let environment = EnvironmentValues(backend: backend)
        .with(\.window, window)
    let viewGraph = ViewGraph(
        for: view(),
        backend: backend,
        environment: environment
    )
    backend.setChild(ofWindow: window, to: viewGraph.rootNode.widget.into())

    return viewGraph.computeLayout(
        proposedSize: proposedSize,
        environment: environment
    )
}
