import DummyBackend
import Testing

@testable import SwiftCrossUI

@Suite("Bindings")
@MainActor
struct BindingTests {
    @Test("get/set")
    func getSet() async throws {
        var value = 42

        let binding = Binding(get: { value }, set: { value = $0 })
        #expect(binding.wrappedValue == 42)

        binding.wrappedValue = 69
        #expect(value == 69)
    }
    
    @Test("Projection")
    func projection() async throws {
        struct Value {
            var string = "hi"
        }
        var value = Value()

        let binding = Binding(get: { value }, set: { value = $0 })

        let projected = binding.string
        #expect(projected.wrappedValue == "hi")

        projected.wrappedValue = "hello"
        #expect(binding.wrappedValue.string == "hello")
        #expect(value.string == "hello")
    }
    
    @Test("onChange")
    func onChange() async throws {
        var value = 42
        var wasChanged = false

        let binding = Binding(get: { value }, set: { value = $0 })
            .onChange { _ in wasChanged = true }

        #expect(!wasChanged)
        binding.wrappedValue = 69
        #expect(binding.wrappedValue == 69)
        #expect(wasChanged)
    }
}
