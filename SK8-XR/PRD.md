# SK8-XR Product Requirements Document
## Crawl Demo — v1

---

## Purpose
A working iOS AR prototype demonstrating 5 rubric features
within the SK8-XR concept frame. Graded demo for CRCP6380, SMU.
Prof: Ryan Vojir. Due: April 2026.

---

## Success Criteria

The demo is DONE when:
- [ ] App builds without errors in Xcode on Mac Mini M4
- [ ] App runs on physical iPhone without crashing
- [ ] All 5 features are visually demonstrable on device
- [ ] A 2-5 min dev environment walkthrough video can be recorded
- [ ] A demo video showing all 5 features with callouts can be recorded

---

## Feature Requirements

### Feature 1 -- Display CAD Model (Basic)
**What it does:** Places a 3D ghost skater figure in the AR scene.
**Implementation:** RealityKit `ModelEntity` using a primitive capsule mesh.
**Stand-in for:** Full mocap ghost skater figure.
**Success:** Capsule appears anchored to a detected plane in the AR view.

### Feature 2 -- Play Animation (Basic)
**What it does:** Ghost figure plays a looping animation.
**Implementation:** `FromToByAnimation` or `OrbitAnimation` on the ModelEntity.
Animation: gentle bob up/down (0.2m over 1.0 second, repeat forever).
**Stand-in for:** Full trick replay animation from mocap data.
**Success:** Ghost visibly animates in a loop without user interaction.

### Feature 3 -- Move Fast/Slow (Basic)
**What it does:** Slider controls animation playback speed in real time.
**Implementation:** SwiftUI `Slider` bound to `SceneState.playbackSpeed`.
Range: 0.1x (nearly frozen) to 2.0x (double speed).
ARViewContainer applies speed to animation controller each frame.
**Stand-in for:** Trick scrubber / slow motion replay.
**Success:** Moving slider visibly changes how fast ghost animates.

### Feature 4 -- Hide/Show (Basic)
**What it does:** Button toggles ghost figure visible/invisible.
**Implementation:** SwiftUI `Button` toggles `SceneState.ghostVisible`.
Sets `ghostEntity.isEnabled = ghostVisible` on the RealityKit entity.
**Stand-in for:** Body part isolation toggle (feet/board/full).
**Success:** Tapping button makes ghost disappear and reappear.

### Feature 5 -- Geo Pointer (Difficult)
**What it does:** A 3D arrow in the AR scene points toward a hardcoded skate spot GPS coordinate.
**Implementation:**
1. `CLLocationManager` gets device current GPS + heading.
2. Bearing computed from device location to target coordinate.
3. A RealityKit arrow entity (cone primitive) rotates to that bearing.
4. Updates live as device moves/rotates.
**Stand-in for:** Location-based spot discovery.
**Success:** Arrow visibly points in the direction of the target skate spot.
Rotates when device changes heading.

---

## Out of Scope for v1
- Real mocap assets (Mixamo, Sketchfab)
- Video-to-3D pipeline
- Community contributions
- User accounts
- Real database or backend
- ARGeoAnchor (replaced by CLLocation bearing)
- Google Maps or Apple Maps SDK
- Fingerboard mode

---

## Demo Script (for video recording)

1. Open app. Camera view loads. Ghost capsule appears on detected surface.
   -- CALLOUT: "Feature 1: 3D model placed in AR scene"

2. Ghost is already animating (bobbing).
   -- CALLOUT: "Feature 2: Looping animation playing"

3. Move slider left. Ghost slows to near freeze.
   Move slider right. Ghost speeds up.
   -- CALLOUT: "Feature 3: Move fast/slow -- scrubber control"

4. Tap Hide/Show button. Ghost disappears. Tap again. Ghost reappears.
   -- CALLOUT: "Feature 4: Hide/show -- body isolation toggle"

5. Point at AR scene showing compass arrow.
   -- CALLOUT: "Feature 5: Geo pointer -- arrow points toward Pease Park Austin TX"
   Walk or rotate device. Arrow updates direction.

---

## Grading Alignment

| Rubric Item | How Satisfied |
|---|---|
| 4+ basic features | Features 1-4 |
| 1+ difficult feature | Feature 5 (geo pointer) |
| Background environment in scene | AR camera feed is the environment |
| Dev environment walkthrough 2-5 min | Xcode screen recording |
| Demo video with callouts | Recorded on device, edited with callouts |
| Feature success/fluidity | Target: smooth, no crashes |
