import RealityKit
import Foundation
import UIKit

class GhostEntity {

    static func make() -> ModelEntity {
        let mesh = MeshResource.generateCylinder(height: 1.8, radius: 0.25)
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
