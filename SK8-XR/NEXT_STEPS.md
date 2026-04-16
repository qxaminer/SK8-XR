# SK8-XR NEXT_STEPS
## Ordered build sequence for Mac Mini session

Execute these in order. Do not skip ahead.
Each step has a clear done condition before moving to the next.

---

## Step 1 -- New Xcode Project
**Action:**
- Open Xcode
- File > New > Project
- Template: Augmented Reality App
- Product Name: SK8XR
- Interface: SwiftUI
- Content Technology: RealityKit
- Language: Swift
- Save to your preferred location

**Delete from default project:**
- Experience.rcproject (not needed)
- ContentView.swift default content (replace entirely)

**Done when:** Project builds clean with no errors on simulator.

---

## Step 2 -- Info.plist Permissions
**Action:** Add two keys to Info.plist:
```
Privacy - Camera Usage Description
Value: "SK8-XR uses camera for AR"

Privacy - Location When In Use Usage Description
Value: "SK8-XR uses location for geo pointer"
```

**Done when:** Keys visible in Info.plist, no build warnings.

---

## Step 3 -- Add Swift Files
**Action:** In Xcode project navigator, right-click SK8XR folder.
New File > Swift File for each:
- SpotData.swift
- SceneState.swift
- GhostEntity.swift
- GeoPointer.swift
- ARViewContainer.swift
- HUDView.swift

Paste contents from AGENTS.md for each file.

**Done when:** All 6 files appear in navigator, no red errors.

---

## Step 4 -- Wire ContentView
**Action:** Replace ContentView.swift with version from AGENTS.md.
This composes ARViewContainer + HUDView with SceneState.

**Done when:** Build succeeds. Simulator shows AR placeholder.

---

## Step 5 -- Test on Device (Features 1-4)
**Action:**
- Select iPhone as build target
- Build and run
- Point camera at floor or flat surface
- Confirm ghost capsule appears on detected plane
- Confirm ghost animates (bobbing)
- Confirm slider changes animation speed
- Confirm button toggles ghost visibility

**Done when:** All 4 basic features working on device.

---

## Step 6 -- Test Geo Pointer (Feature 5)
**Action:**
- Go outside or near a window with GPS signal
- Confirm arrow appears in AR scene
- Walk or rotate -- confirm arrow updates direction
- Verify arrow points roughly toward Austin TX (if in Austin)
  or toward Austin from your current location

**Done when:** Arrow visible and updates with device movement.

---

## Step 7 -- Record Dev Walkthrough Video
**Action:**
- Screen record Xcode (2-5 min)
- Show: project structure, each Swift file, build process, simulator/device run
- Narrate each feature as you demo it

**Done when:** Video file saved, 2-5 min, all 5 features shown.

---

## Step 8 -- Record Demo Video
**Action:**
- Record iPhone screen or use external camera on device
- Follow demo script from PRD.md exactly
- Add callouts in iMovie or CapCut after recording

**Done when:** Demo video with all 5 callouts complete.

---

## If Anything Breaks

**Ghost not appearing:** Check plane detection is enabled in ARViewContainer.
ARWorldTrackingConfiguration requires detected plane before anchor placement.
Point camera at floor for 3-5 seconds.

**Geo pointer not updating:** Check CLLocationManager authorization.
Must be requested at runtime. Check SpotData.swift has valid coordinates.

**Build errors on first open:** Check all 6 Swift files are added to the
target (check Target Membership in File Inspector for each file).

**Animation not playing:** Confirm animationController is being stored
as a property, not a local variable (gets deallocated otherwise).
