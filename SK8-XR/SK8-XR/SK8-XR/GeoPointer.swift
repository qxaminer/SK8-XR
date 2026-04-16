import RealityKit
import CoreLocation
import Foundation
import UIKit

class GeoPointer: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    private weak var arrowEntity: ModelEntity?
    var onBearingUpdate: ((Float) -> Void)?

    private var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    static func makeArrow() -> ModelEntity {
        let mesh = MeshResource.generateCone(height: 0.4, radius: 0.15)
        var material = SimpleMaterial()
        material.color = .init(tint: .cyan.withAlphaComponent(0.9))
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.name = "geoArrow"
        entity.position = SIMD3<Float>(0, 1.8, -1.5)
        return entity
    }

    func setArrow(_ entity: ModelEntity) {
        self.arrowEntity = entity
    }

    // Bearing in degrees from device to target
    private func bearing(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Float {
        let lat1 = from.latitude * .pi / 180
        let lat2 = to.latitude * .pi / 180
        let dLon = (to.longitude - from.longitude) * .pi / 180

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let bearing = atan2(y, x)
        return Float(bearing)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        updateArrow()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        updateArrow()
    }

    private func updateArrow() {
        guard let current = currentLocation else { return }
        let target = SpotData.nearest.coordinate
        let bearingRad = bearing(from: current.coordinate, to: target)
        DispatchQueue.main.async {
            self.arrowEntity?.transform.rotation = simd_quatf(
                angle: bearingRad,
                axis: SIMD3<Float>(0, 1, 0)
            )
            self.onBearingUpdate?(bearingRad)
        }
    }
}
