/// A shape with a rotation transform.
public struct RotatedShape<Content: Shape>: Shape {
    /// The underlying shape.
    public var shape: Content
    /// The rotation angle.
    public var angle: Angle
    /// The anchor point for the rotation.
    public var anchor: SIMD2<Double>

    /// Applies a rotation transform to a shape.
    ///
    /// - Parameters:
    ///   - shape: The underlying shape.
    ///   - angle: The rotation angle.
    ///   - anchor: The anchor point for the rotation.
    public init(shape: Content, angle: Angle, anchor: SIMD2<Double>) {
        self.shape = shape
        self.angle = angle
        self.anchor = anchor
    }

    public nonisolated func path(in bounds: Path.Rect) -> Path {
        shape.path(in: bounds)
            .applyTransform(.rotation(angle: angle, center: anchor))
    }
}

extension Shape {
    /// Applies a rotation transform to this shape.
    @MainActor
    public func rotation(_ angle: Angle, anchor: SIMD2<Double>) -> RotatedShape<Self> {
        RotatedShape(shape: self, angle: angle, anchor: anchor)
    }
}
