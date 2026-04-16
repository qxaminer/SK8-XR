# SK8-XR Architecture

## Overview
Native iOS AR app built with Swift, SwiftUI, ARKit, and RealityKit.
Demonstrates 5 rubric features anchored to the SK8-XR concept.
No external assets required for v1 Crawl demo.

---

## Feature Map (Rubric Compliance)

| # | Feature | Rubric Category | SK8-XR Concept |
|---|---------|----------------|----------------|
| 1 | Display CAD model | Basic | Ghost skater (primitive stand-in) |
| 2 | Play animation | Basic | Trick replay loop |
| 3 | Move fast/slow | Basic | Scrubber / playback speed |
| 4 | Hide/show | Basic | Body isolation toggle |
| 5 | Geo pointer | Difficult | Points to hardcoded skate spot GPS |

---

## System Components

```
SK8XR/
├── App Entry
│   └── SK8XRApp.swift          -- @main entry point
│
├── AR Layer (RealityKit + ARKit)
│   ├── ARViewContainer.swift   -- UIViewRepresentable wrapping ARView
│   ├── GhostEntity.swift       -- The skater ghost (ModelEntity + animation)
│   └── GeoPointer.swift        -- Compass arrow pointing to target GPS coord
│
├── UI Layer (SwiftUI)
│   ├── ContentView.swift       -- Root view, composes AR + HUD
│   └── HUDView.swift           -- Scrubber slider, hide/show button, speed label
│
└── Data
    └── SpotData.swift          -- Hardcoded GPS coords for skate spots
```

---

## Data Flow

```
ContentView
    |
    ├── ARViewContainer (renders AR scene)
    │       |
    │       ├── GhostEntity (ModelEntity)
    │       │       ├── isVisible: Bool  <-- driven by HUD toggle
    │       │       └── speed: Float     <-- driven by HUD slider
    │       │
    │       └── GeoPointer
    │               └── targetCoord: CLLocationCoordinate2D
    │
    └── HUDView (SwiftUI overlay)
            ├── Slider (0.1x to 2.0x) --> speed binding
            └── Button (Show/Hide)    --> isVisible binding
```

---

## State Management

Single `@StateObject class SceneState: ObservableObject` owns:
- `var ghostVisible: Bool = true`
- `var playbackSpeed: Float = 1.0`

Both `ARViewContainer` and `HUDView` observe `SceneState`.
No networking. No external data. No asset pipeline.

---

## Feature 5: Geo Pointer (Difficult)

Uses `CLLocationManager` to get device GPS.
Computes bearing from device to hardcoded target coordinate.
Renders a 3D arrow entity in the AR scene rotated to that bearing.
Updates on device heading change.

Target coordinates (hardcoded in SpotData.swift):
- Pease Park, Austin TX: 30.2785, -97.7594
- Charlottesville VA skate spot: 38.0293, -78.4767

No `ARGeoAnchor` required. No Apple Maps dependency.
Pure CLLocation math -- works anywhere with GPS signal.

---

## Constraints and Decisions

- No Mixamo/Sketchfab assets in v1. Ghost is a RealityKit primitive (capsule).
- No real mocap pipeline. Animation is a simple bob/rotate loop via `OrbitAnimation` or `FromToByAnimation`.
- No backend, no database, no network calls.
- Targets iOS 16+ for RealityKit 2 compatibility.
- Builds in Xcode 15+ on Mac Mini M4.
- Device test target: any iPhone with LiDAR preferred, A12+ required for ARKit.

---

## What "Done" Looks Like

1. App opens to AR camera view with a capsule ghost visible in scene.
2. Ghost plays a looping animation (bob up/down or slow spin).
3. Slider at bottom controls animation speed in real time.
4. Button toggles ghost visible/invisible.
5. A 3D arrow in the scene points toward the nearest hardcoded skate spot.
