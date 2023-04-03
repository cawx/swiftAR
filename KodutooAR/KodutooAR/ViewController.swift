
import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pindade leidmine
        planeDetect()
        // mudeli importimine ja asetamine stseeni keskele
        let model = try! Entity.loadModel(named: "cup_saucer_set")
        let entityAnchor = AnchorEntity(world: SIMD3(x: 0, y: 0, z: 0))
        entityAnchor.addChild(model)
        arView.scene.addAnchor(entityAnchor)
        // vajutades tekib uus objekt
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        // objekti funktsionaalsused
        model.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .scale, .translation], for: model)
    }
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: arView)
        let result = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        if let firstResult = result.first {
            let worldPos = simd_make_float3(firstResult.worldTransform.columns.3)
            let cup = createCup()
            placeObj(object: cup, at: worldPos)
        }
    }
    
    func createCup() -> Entity {
        let url = URL(string: "./cup_saucer_set")
        let model = try! Entity.loadModel(named: "cup_saucer_set")
        return model
    }
    
    func planeDetect() {
        arView.automaticallyConfigureSession = true
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)
    }
    
    func placeObj(object: Entity, at location: SIMD3<Float>) {
        let objectAnchor = AnchorEntity(world: location)
        objectAnchor.addChild(object)
        arView.scene.addAnchor(objectAnchor)
    }
}
