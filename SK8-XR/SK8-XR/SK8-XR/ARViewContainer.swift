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
