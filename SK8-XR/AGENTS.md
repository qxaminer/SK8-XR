# SK8-XR AGENTS.md
## Xcode Agent Prompt Templates + Complete Swift File Contents

Each section below is a self-contained prompt.
Copy and paste directly into your Xcode AI agent.
Do not combine prompts. Execute one at a time.
Wait for confirmation before moving to the next.

---

## AGENT PROMPT 1 -- SpotData.swift

Paste this prompt to your Xcode agent:

```
Create a new Swift file called SpotData.swift in the SK8XR target.
Replace its entire contents with exactly the following:

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

Do not add any other code. Save the file.
```

---

## AGENT PROMPT 2 -- SceneState.swift

```
Create a new Swift file called SceneState.swift in the SK8XR target.
Replace its entire contents with exactly the following:

import Foundation
import Combine

class SceneState: ObservableObject {
    @Published var ghostVisible: Bool = true
    @Published var playbackSpeed: Float = 1.0
}

Do not add any other code. Save the file.
```

---

## AGENT PROMPT 3 -- GhostEntity.swift

```
Create a new Swift file called GhostEntity.swift in the SK8XR target.
Replace its entire contents with exactly the following:

import RealityKit
import Foundation

class GhostEntity {

    static func make() -> ModelEntity {
        let mesh = MeshResource.generateCapsule(height: 1.8, radius: 0.25)
        var material = SimpleMaterial()
        material.color = .init(tint: .green.withAlphaComponent(0.7))
        material.metallic = 0.0
        material.roughness = 1.0
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.name = "ghost"
        entity.position = SIMD3<Float>(0, 0.9, -1.5)
        return entity
    }

    static func addAnimation(to entity: ModelEntity) -> AnimationPlaybackController? {
        let start = Transform(translation: entity.position)
        var end = start
        end.translation.y += 0.2

        let animation = FromToByAnimation<Transform>(
            name: "bob",
            from: start,
            to: end,
            duration: 1.0,
            timing: .easeInOut,
            bindTarget: .transform,
            repeatMode: .autoReverse
        )

        do {
            let resource = try AnimationResource.generate(with: animation)
            return entity.playAnimation(resource, transitionDuration: 0.0, startsPaused: false)
        } catch {
            print("SK8XR: animation error \(error)")
            return nil
        }
    }
}

Do not add any other code. Save the file.
```

---

## AGENT PROMPT 4 -- GeoPointer.swift

```
Create a new Swift file called GeoPointer.swift in the SK8XR target.
Replace its entire contents with exactly the following:

import RealityKit
import CoreLocation
import Foundation

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

Do not add any other code. Save the file.
```

---

## AGENT PROMPT 5 -- ARViewContainer.swift

```
Create a new Swift file called ARViewContainer.swift in the SK8XR target.
Replace its entire contents with exactly the following:

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {

    @ObservedObject var sceneState: SceneState

    private static var ghostEntity: ModelEntity?
    private static var animController: AnimationPlaybackController?
    private static var geoPointer = GeoPointer()
    private static var arrowEntity: ModelEntity?

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)

        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [0.3, 0.3]))

        let ghost = GhostEntity.make()
        ARViewContainer.ghostEntity = ghost
        ARViewContainer.animController = GhostEntity.addAnimation(to: ghost)
        anchor.addChild(ghost)

        let arrow = GeoPointer.makeArrow()
        ARViewContainer.arrowEntity = arrow
        ARViewContainer.geoPointer.setArrow(arrow)
        anchor.addChild(arrow)

        arView.scene.anchors.append(anchor)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        ARViewContainer.ghostEntity?.isEnabled = sceneState.ghostVisible

        if let controller = ARViewContainer.animController {
            controller.speed = sceneState.playbackSpeed
        }
    }
}

Do not add any other code. Save the file.
```

---

## AGENT PROMPT 6 -- HUDView.swift

```
Create a new Swift file called HUDView.swift in the SK8XR target.
Replace its entire contents with exactly the following:

import SwiftUI

struct HUDView: View {

    @ObservedObject var sceneState: SceneState

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {

                HStack {
                    Text("Speed")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                    Slider(value: $sceneState.playbackSpeed, in: 0.1...2.0)
                        .accentColor(.green)
                    Text(String(format: "%.1fx", sceneState.playbackSpeed))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.green)
                        .frame(width: 36)
                }
                .padding(.horizontal)

                Button(action: {
                    sceneState.ghostVisible.toggle()
                }) {
                    Text(sceneState.ghostVisible ? "Hide Ghost" : "Show Ghost")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(sceneState.ghostVisible ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

            }
            .padding(.vertical, 16)
            .background(Color.black.opacity(0.6))
            .cornerRadius(16)
            .padding()
        }
    }
}

Do not add any other code. Save the file.
```

---

## AGENT PROMPT 7 -- ContentView.swift

```
Replace the entire contents of ContentView.swift with exactly the following:

import SwiftUI

struct ContentView: View {

    @StateObject private var sceneState = SceneState()

    var body: some View {
        ZStack {
            ARViewContainer(sceneState: sceneState)
                .ignoresSafeArea()
            HUDView(sceneState: sceneState)
        }
    }
}

Do not add any other code. Save the file.
```

---

## AGENT PROMPT 8 -- Final Check

```
Please do the following checks:

1. Confirm all 7 files exist in the SK8XR target:
   SpotData.swift, SceneState.swift, GhostEntity.swift,
   GeoPointer.swift, ARViewContainer.swift, HUDView.swift, ContentView.swift

2. Confirm Info.plist has both:
   - NSCameraUsageDescription
   - NSLocationWhenInUseUsageDescription

3. Build the project (Cmd+B). Report any errors exactly.

4. If there are errors, fix only what is reported.
   Do not refactor or rewrite any file unless it has an error.
```

---

## Notes for Agent

- Always fix errors in isolation. Do not rewrite working files.
- If an animation API is unavailable, report it -- do not substitute silently.
- The ghost is intentionally a capsule primitive. Do not substitute a complex model.
- GeoPointer uses CLLocation bearing math only. Do not add MapKit or ARGeoAnchor.
- All state lives in SceneState. Do not add @State vars to ARViewContainer.
