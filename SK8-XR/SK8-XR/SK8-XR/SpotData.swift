import CoreLocation

struct SkateSpot {
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct SpotData {
    static let spots: [SkateSpot] = [
        SkateSpot(
            name: "Pease Park",
            coordinate: CLLocationCoordinate2D(latitude: 30.2785, longitude: -97.7594)
        ),
        SkateSpot(
            name: "Charlottesville",
            coordinate: CLLocationCoordinate2D(latitude: 38.0293, longitude: -78.4767)
        )
    ]

    static var nearest: SkateSpot {
        return spots[0]
    }
}
