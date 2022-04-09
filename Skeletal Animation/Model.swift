// Developed by Kelin.Lyu.
import SpriteKit
import SceneKit
class Model: SCNNode {
    var animations: [String : Animation] = [:]
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    init(node: SCNNode, scale: Float) {
        super.init()
        let targetNode: SCNNode = node.clone()
        for n in targetNode.childNodes {
            self.addChildNode(n)
        }
        self.scale = SCNVector3(scale)
    }
    convenience init(file: String, scale: Float) {
        let node = SCNNode()
        if let scene = SCNScene(named: "\(file).scn") {
            for n in scene.rootNode.childNodes {
                node.addChildNode(n)
            }
        }else{
            fatalError()
        }
        self.init(node: node, scale: scale)
    }
    @discardableResult func add(animation name: String, file: String, continuous: Bool,
                                speed: CGFloat, blendFactor: CGFloat,
                                fadeInDuration: CGFloat, fadeOutDuration: CGFloat,
                                events: [SCNAnimationEvent], remove: Bool,
                                useLoadedAnimation: Bool = false)->(Animation) {
        let animation = Animation(name: name, file: file, continuous: continuous,
                                  speed: speed, blendFactor: blendFactor,
                                  fadeInDuration: fadeInDuration,
                                  fadeOutDuration: fadeOutDuration,
                                  events: events, remove: remove, model: self,
                                  useLoadedAnimation: useLoadedAnimation)
        self.animations[name] = animation
        return(animation)
    }
    func get(animation name: String)->(Animation?) {
        if let animation = self.animations[name] {
            return(animation)
        }
        return(nil)
    }
    func play(animation name: String, fadeInDuration: CGFloat? = nil,
              newSpeed: CGFloat? = nil, newBlendFactor: CGFloat? = nil) {
        if let animation = self.animations[name] {
            animation.play(fadeInDuration: fadeInDuration, newSpeed: newSpeed, newBlendFactor: newBlendFactor)
        }
    }
    func stop(animation name: String, fadeOutDuration: CGFloat? = nil) {
        if let animation = self.animations[name] {
            animation.stop(fadeOutDuration: fadeOutDuration)
        }
    }
    func stopAllAnimations(except list: [String]) {
        for animation in self.animations {
            if(!list.contains(animation.key)) {
                self.stop(animation: animation.key)
            }
        }
    }
    func destroy() {
        for animation in self.animations.values {
            animation.destroy()
        }
        self.animations.removeAll()
    }
    @objc dynamic func update(at time: TimeInterval) {
        for data in self.animations {
            data.value.update(at: time)
        }
    }
    @objc dynamic func render(at time: TimeInterval) {}
}
