/// A shape with a scale transform.
///
/// The shape is scaled **without changing its bounding frame**. This means
/// shapes scaled with a factor greater than 1.0 will likely be clipped. Use
/// ``frame(width:height:alignment:)->View`` instead if you want to change the
/// shape's size along with its bounding frame.
public struct ScaledShape<Content: Shape>: Shape {
    /// The underlying shape.
    public var shape: Content
    /// The scaling factor.
    public var scale: Double

    /// Applies a scale transform to a shape.
    ///
    /// - Parameters:
    ///   - shape: The underlying shape.
    ///   - angle: The scaling factor.
    public init(shape: Content, scale: Double) {
        self.shape = shape
        self.scale = scale
    }

    // we deliberately use the default implementation for size(fitting:)

    public nonisolated func path(in bounds: Path.Rect) -> Path {
        shape.path(in: bounds)
            .applyTransform(.scaling(by: scale))
    }
}

extension Shape {
    /// Applies a scale transform to this shape.
    ///
    /// The shape is scaled **without changing its bounding frame**. This means
    /// shapes scaled with a factor greater than 1.0 will likely be clipped. Use
    /// ``View/frame(width:height:alignment:)`` instead if you want to change
    /// the shape's size along with its bounding frame.
    @MainActor
    public func scaled(_ scale: Double) -> ScaledShape<Self> {
        ScaledShape(shape: self, scale: scale)
    }
}
