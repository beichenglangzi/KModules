// Developed by Kelin.Lyu.
import SpriteKit
import SceneKit
extension SCNAnimationPlayer {
    convenience init(load file: String) {
        var animationPlayer: SCNAnimationPlayer!
        autoreleasepool {
            let fileURL: URL = Bundle.main.url(forResource: file, withExtension: "dae")!
            let source: SCNSceneSource = SCNSceneSource(url: fileURL, options: nil)!
            let scene: SCNScene = try! source.scene(options: nil)
            func searchForAnimation(node: SCNNode) {
                if(animationPlayer == nil) {
                    if(node.animationKeys.count > 0) {
                        animationPlayer = node.animationPlayer(forKey: node.animationKeys[0])!
                    }else{
                        for n in node.childNodes {
                            searchForAnimation(node: n)
                        }
                    }
                }
            }
            for node in scene.rootNode.childNodes {
                searchForAnimation(node: node)
            }
            if(animationPlayer == nil) {
                fatalError()
            }
        }
        self.init(animation: animationPlayer.animation)
    }
}
