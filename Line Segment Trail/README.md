# Line Segment Trail
### Basic Usage
You will find this module helpful if you want to add a trail effect following a game object for your SceneKit game. The short video below demonstrates what effect this module creates. To get started, drag the two swift files into your project. Note that if you have already added the SCNVector3.swift file, you can skip that one. If you are trying this module for the first time, you are recommended to create a new project, add a SCNCube, and apply some movement animations to keep it flying around.

[![Demo](https://github.com/KelinLyu/KModules/blob/main/GitHub%20Images/Trail%20Demo.gif)](#)

First, before creating the trail effect, you need to add two child nodes named "trailTip" and "trailEnd" to the target SCNNode. You can either do that programmatically or take advantage of Xcode's scene editor. Also, you need to prepare a SCNMaterial object ahead of time. For example, you can write the following code to create a blank material:
```
let trailMaterial: SCNMaterial = SCNMaterial()
trailMaterial.lightingModel = .constant
trailMaterial.diffuse.contents = UIColor.white
trailMaterial.isDoubleSided = true
```
Then, create a trail object:
```
var trail: Trail = Trail(for: node, scene: scene, material: trailMaterial, renderingOrder: 100, smoothen: true, fragmentShader: nil)
```
The parameters of the constructor are described below:
- node: the target node to which you want to attach the trail.
- scene: the current SCNScene object.
- material: the material you prepared for the trail effect.
- renderingOrder: the rendering order. Since the trail effects are semi-transparent in most cases, you should make the trail's render order higher than other opaque nodes.
- smoothen: whether to use the interpolation algorithms. If set to false, the trail effect will use algorihm1 shown in the video, which is fast but has sharp corners. Otherwise, it will use algorithm3, which looks better but has complex computations.
- fragmentShader: provide a metal fragment shader and attach it to the trail effect. I recommend that you write the fragment shader directly into the material instead of putting it as a parameter here.

Then, you need to implement the willRenderScene function, one of the renderer functions of the SCNSceneRendererDelegate protocol, and there, you need to call the render function of the trail object:
```
func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
    trail.render()
}
```
Finally, you need to enable it to make the effect show up.
```
trail.enabled = true
```
### Advanced Tips
