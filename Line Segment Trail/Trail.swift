// Developed by Kelin.Lyu.
import SpriteKit
import SceneKit
class Trail {
    var trailNode: SCNNode!
    var enabled: Bool = false
    var resetIndex: Int = 5
    var targetNode: SCNNode!
    var trailTipLocation: SCNVector3!
    var trailEndLocation: SCNVector3!
    var locationData: [(location1: SCNVector3, location2: SCNVector3)] = []
    var geometry: SCNPlane!
    init(for node: SCNNode, scene: SCNScene, material: SCNMaterial, renderingOrder: Int, smoothen: Bool, fragmentShader: String? = nil) {
        self.targetNode = node
        for child in self.targetNode.childNodes {
            if(child.name == "trailTip") {
                self.trailTipLocation = child.position
                child.removeFromParentNode()
            }else if(child.name == "trailEnd") {
                self.trailEndLocation = child.position
                child.removeFromParentNode()
            }
        }
        if(self.trailTipLocation == nil)||(self.trailEndLocation == nil) {
            fatalError()
        }
        self.geometry = SCNPlane(width: 40, height: 10)
        self.geometry.widthSegmentCount = 16
        self.geometry.heightSegmentCount = 1
        self.geometry.cornerRadius = 0
        self.geometry.cornerSegmentCount = 1
        var shaders: [SCNShaderModifierEntryPoint : String] = [:]
        if(smoothen) {
            shaders[SCNShaderModifierEntryPoint.geometry] = """
            uniform vec3 location_0_1;
            uniform vec3 location_0_2;
            uniform vec3 location_1_1;
            uniform vec3 location_1_2;
            uniform vec3 location_2_1;
            uniform vec3 location_2_2;
            uniform vec3 location_3_1;
            uniform vec3 location_3_2;
            uniform vec3 location_4_1;
            uniform vec3 location_4_2;
            vec4 position = _geometry.position;
            if(position.x < -19) {
                if(position.y < 0) {
                    position.xyz = location_0_1;
                }else{
                    position.xyz = location_0_2;
                }
            }else if(position.x < -16) {
                if(position.y < 0) {
                    position.xyz = location_0_1 * 0.715 + location_1_1 * 0.36 - location_2_1 * 0.075;
                }else{
                    position.xyz = location_0_2 * 0.715 + location_1_2 * 0.36 - location_2_2 * 0.075;
                }
            }else if(position.x < -14) {
                if(position.y < 0) {
                    position.xyz = location_0_1 * 0.425 + location_1_1 * 0.66 - location_2_1 * 0.085;
                }else{
                    position.xyz = location_0_2 * 0.425 + location_1_2 * 0.66 - location_2_2 * 0.085;
                }
            }else if(position.x < -12) {
                if(position.y < 0) {
                    position.xyz = location_0_1 * 0.185 + location_1_1 * 0.86 - location_2_1 * 0.045;
                }else{
                    position.xyz = location_0_2 * 0.185 + location_1_2 * 0.86 - location_2_2 * 0.045;
                }
            }else if(position.x < -9) {
                if(position.y < 0) {
                    position.xyz = location_1_1;
                }else{
                    position.xyz = location_1_2;
                }
            }else if(position.x < -6) {
                if(position.y < 0) {
                    position.xyz = location_1_1 * 0.795 + location_2_1 * 0.325 - location_0_1 * 0.045 - location_3_1 * 0.075;
                }else{
                    position.xyz = location_1_2 * 0.795 + location_2_2 * 0.325 - location_0_2 * 0.045 - location_3_2 * 0.075;
                }
            }else if(position.x < -4) {
                if(position.y < 0) {
                    position.xyz = location_1_1 * 0.58 + location_2_1 * 0.58 - location_0_1 * 0.08 - location_3_1 * 0.08;
                }else{
                    position.xyz = location_1_2 * 0.58 + location_2_2 * 0.58 - location_0_2 * 0.08 - location_3_2 * 0.08;
                }
            }else if(position.x < -2) {
                if(position.y < 0) {
                    position.xyz = location_1_1 * 0.325 + location_2_1 * 0.795 - location_0_1 * 0.075 - location_3_1 * 0.045;
                }else{
                    position.xyz = location_1_2 * 0.325 + location_2_2 * 0.795 - location_0_2 * 0.075 - location_3_2 * 0.045;
                }
            }else if(position.x < 1) {
                if(position.y < 0) {
                    position.xyz = location_2_1;
                }else{
                    position.xyz = location_2_2;
                }
            }else if(position.x < 3) {
                if(position.y < 0) {
                    position.xyz = location_2_1 * 0.795 + location_3_1 * 0.325 - location_1_1 * 0.045 - location_4_1 * 0.075;
                }else{
                    position.xyz = location_2_2 * 0.795 + location_3_2 * 0.325 - location_1_2 * 0.045 - location_4_2 * 0.075;
                }
            }else if(position.x < 6) {
                if(position.y < 0) {
                    position.xyz = location_2_1 * 0.58 + location_3_1 * 0.58 - location_1_1 * 0.08 - location_4_1 * 0.08;
                }else{
                    position.xyz = location_2_2 * 0.58 + location_3_2 * 0.58 - location_1_2 * 0.08 - location_4_2 * 0.08;
                }
            }else if(position.x < 9) {
                if(position.y < 0) {
                    position.xyz = location_2_1 * 0.325 + location_3_1 * 0.795 - location_1_1 * 0.075 - location_4_1 * 0.045;
                }else{
                    position.xyz = location_2_2 * 0.325 + location_3_2 * 0.795 - location_1_2 * 0.075 - location_4_2 * 0.045;
                }
            }else if(position.x < 11) {
                if(position.y < 0) {
                    position.xyz = location_3_1;
                }else{
                    position.xyz = location_3_2;
                }
            }else if(position.x < 13) {
                if(position.y < 0) {
                    position.xyz = location_3_1 * 0.86 + location_4_1 * 0.18 - location_2_1 * 0.04;
                }else{
                    position.xyz = location_3_2 * 0.86 + location_4_2 * 0.18 - location_2_2 * 0.04;
                }
            }else if(position.x < 16) {
                if(position.y < 0) {
                    position.xyz = location_3_1 * 0.66 + location_4_1 * 0.42 - location_2_1 * 0.08;
                }else{
                    position.xyz = location_3_2 * 0.66 + location_4_2 * 0.42 - location_2_2 * 0.08;
                }
            }else if(position.x < 19) {
                if(position.y < 0) {
                    position.xyz = location_3_1 * 0.36 + location_4_1 * 0.71 - location_2_1 * 0.07;
                }else{
                    position.xyz = location_3_2 * 0.36 + location_4_2 * 0.71 - location_2_2 * 0.07;
                }
            }else{
                if(position.y < 0) {
                    position.xyz = location_4_1;
                }else{
                    position.xyz = location_4_2;
                }
            }
            _geometry.position = position;
            """
        }else{
            shaders[SCNShaderModifierEntryPoint.geometry] = """
            uniform vec3 location_0_1;
            uniform vec3 location_0_2;
            uniform vec3 location_1_1;
            uniform vec3 location_1_2;
            uniform vec3 location_2_1;
            uniform vec3 location_2_2;
            uniform vec3 location_3_1;
            uniform vec3 location_3_2;
            uniform vec3 location_4_1;
            uniform vec3 location_4_2;
            vec4 position = _geometry.position;
            if(position.x < -15) {
                if(position.y < 0) {
                    position.xyz = location_0_1;
                }else{
                    position.xyz = location_0_2;
                }
            }else if(position.x < -5) {
                if(position.y < 0) {
                    position.xyz = location_1_1;
                }else{
                    position.xyz = location_1_2;
                }
            }else if(position.x < 5) {
                if(position.y < 0) {
                    position.xyz = location_2_1;
                }else{
                    position.xyz = location_2_2;
                }
            }else if(position.x < 15) {
                if(position.y < 0) {
                    position.xyz = location_3_1;
                }else{
                    position.xyz = location_3_2;
                }
            }else{
                if(position.y < 0) {
                    position.xyz = location_4_1;
                }else{
                    position.xyz = location_4_2;
                }
            }
            _geometry.position = position;
            """
        }
        if let shader = fragmentShader {
            shaders[SCNShaderModifierEntryPoint.fragment] = shader
        }
        self.geometry.shaderModifiers = shaders
        for i in 0...4 {
            self.locationData.append((location1: .zero, location2: .zero))
            self.geometry.setValue(self.locationData[i].location1, forKey: "location_\(i)_1")
            self.geometry.setValue(self.locationData[i].location2, forKey: "location_\(i)_2")
        }
        self.geometry.materials = [material]
        self.trailNode = SCNNode(geometry: self.geometry)
        self.trailNode.castsShadow = false
        self.trailNode.renderingOrder = renderingOrder
        scene.rootNode.addChildNode(self.trailNode)
    }
    func setShaderValues() {
        for i in 0...4 {
            let location1 = self.trailNode.convertPosition(self.locationData[i].location1, from: nil)
            let location2 = self.trailNode.convertPosition(self.locationData[i].location2, from: nil)
            self.geometry.setValue(location1, forKey: "location_\(i)_1")
            self.geometry.setValue(location2, forKey: "location_\(i)_2")
        }
    }
    func render(scaleFactor: Float = 1) {
        if(self.trailNode == nil) {
            return
        }
        self.trailNode.position = self.targetNode.positionInWorld
        let newLocation1 = self.targetNode.presentation.convertPosition(self.trailTipLocation, to: nil)
        let newLocation2 = self.targetNode.presentation.convertPosition(self.trailEndLocation, to: nil)
        for i in 1...4 {
            let index: Int = 5 - i
            if(i < self.resetIndex) {
                if(!self.enabled) {
                    self.locationData[index].location1 = newLocation1
                    self.locationData[index].location2 = newLocation2
                }
            }else{
                let targetLocation1: SCNVector3 = self.locationData[index - 1].location1
                let targetLocation2: SCNVector3 = self.locationData[index - 1].location2
                self.locationData[index].location1 = targetLocation2 + (targetLocation1 - targetLocation2) * scaleFactor
                self.locationData[index].location2 = targetLocation1 + (targetLocation2 - targetLocation1) * scaleFactor
            }
        }
        self.locationData[0].location1 = newLocation1
        self.locationData[0].location2 = newLocation2
        if(enabled) {
            if(resetIndex > 0) {
                resetIndex -= 1
            }else{
                resetIndex = 0
            }
        }else{
            if(resetIndex < 5) {
                resetIndex += 1
            }else{
                resetIndex = 5
            }
        }
        self.setShaderValues()
    }
    func destroy() {
        self.enabled = false
        self.trailNode.removeFromParentNode()
        self.trailNode = nil
    }
}
extension SCNNode {
    var positionInWorld: SCNVector3 {
        let location = SCNVector3(self.presentation.worldTransform.m41,
                                  self.presentation.worldTransform.m42,
                                  self.presentation.worldTransform.m43)
        return(location)
    }
}

