/// A geometric angle, specified in either radians or degrees.
public struct Angle: Sendable, Equatable, Hashable {
    /// The number of radians per degree.
    ///
    /// This is equal to π/180, or about 0.0175.
    private static let radiansPerDegree: Double = .pi / 180.0

    /// The angle in radians.
    private var angleInRadians: Double

    /// Creates an ``Angle`` with the given value, measured in radians.
    public init(radians: Double) {
        self.angleInRadians = radians
    }

    /// Creates an ``Angle`` with the given value, measured in degrees.
    public init(degrees: Double) {
        self.angleInRadians = degrees * Angle.radiansPerDegree
    }

    /// Creates an ``Angle`` with the given value, measured in radians.
    public static func radians(_ radians: Double) -> Angle {
        Angle(radians: radians)
    }

    /// Creates an ``Angle`` with the given value, measured in degrees.
    public static func degrees(_ degrees: Double) -> Angle {
        Angle(degrees: degrees)
    }

    /// The zero angle.
    public static var zero: Angle {
        Angle(radians: 0)
    }

    /// Gets this angle's value in radians.
    public var radians: Double {
        angleInRadians
    }

    /// Gets this angle's value in degrees.
    public var degrees: Double {
        angleInRadians / Angle.radiansPerDegree
    }
}
