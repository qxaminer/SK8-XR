# SK8-XR

Location-based AR skateboarding instruction tool.
Crawl demo v1 -- CRCP6380 Final Project, SMU Creative Technology.

---

## Concept

SK8-XR anchors 3D ghost skater figures to real-world skate spots.
Users can watch tricks in AR, control playback speed, isolate body parts,
and navigate to spots using a live geo pointer.

This demo is a proof of concept using primitive stand-ins for full assets.

---

## 5 Demo Features

| Feature | Rubric | Description |
|---------|--------|-------------|
| Display ghost figure | Basic | RealityKit capsule placed on detected surface |
| Looping animation | Basic | Ghost bobs up/down continuously |
| Speed slider | Basic | Controls animation rate 0.1x to 2.0x |
| Hide/show toggle | Basic | Button makes ghost appear/disappear |
| Geo pointer | Difficult | 3D arrow points toward hardcoded skate spot GPS |

---

## Requirements

- Mac with Xcode 15+
- iPhone A12+ (iOS 16+), LiDAR preferred
- Apple Developer account (free tier works for device testing)
- No external assets, no backend, no API keys

---

## Project Structure

```
SK8XR/
├── SK8XRApp.swift
├── ContentView.swift
├── ARViewContainer.swift
├── GhostEntity.swift
├── GeoPointer.swift
├── HUDView.swift
└── SpotData.swift
```

---

## Setup in Xcode

1. Open Xcode. File > New > Project.
2. Choose "Augmented Reality App" template.
3. Product Name: SK8XR
4. Interface: SwiftUI
5. Content Technology: RealityKit
6. Delete default ContentView and Experience.rcproject.
7. Add each .swift file from this repo into the project navigator.
8. In Info.plist add:
   - Privacy - Camera Usage Description: "SK8-XR uses camera for AR"
   - Privacy - Location When In Use Usage Description: "SK8-XR uses location for geo pointer"
9. Select your iPhone as build target.
10. Build and run.

---

## Skate Spot Coordinates (hardcoded)

- Pease Park, Austin TX: 30.2785, -97.7594
- Charlottesville VA: 38.0293, -78.4767

---

## Related Docs

- ARCHITECTURE.md -- system design and data flow
- PRD.md -- feature requirements and demo script
- NEXT_STEPS.md -- ordered build tasks
- AGENTS.md -- Xcode agent prompt templates
