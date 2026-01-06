import DummyBackend
import Testing

@testable import SwiftCrossUI

@Suite("Frame modifier")
@MainActor
struct FrameTests {
    @Test("minWidth/minHeight")
    func minimumBounds() async throws {
        do {
            let result = computeLayoutForView(proposedSize: ProposedViewSize(100, 100)) {
                Color.blue.frame(minWidth: 150, minHeight: 200)
            }

            #expect(result.size == ViewSize(150, 200))
        }

        do {
            let result = computeLayoutForView(proposedSize: ProposedViewSize(100, 100)) {
                Color.blue.frame(minWidth: 20, minHeight: 40)
            }

            #expect(result.size == ViewSize(100, 100))
        }
    }

    @Test("maxWidth/maxHeight")
    func maximumBounds() async throws {
        do {
            let result = computeLayoutForView(proposedSize: ProposedViewSize(100, 100)) {
                Color.blue.frame(maxWidth: 50, maxHeight: 75)
            }

            #expect(result.size == ViewSize(50, 75))
        }

        do {
            let result = computeLayoutForView(proposedSize: ProposedViewSize(100, 100)) {
                Color.blue.frame(maxWidth: 130, maxHeight: 130)
            }

            #expect(result.size == ViewSize(100, 100))
        }
    }
}
