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
var trail: Trail = Trail(for: node, 
                         scene: scene, 
                         material: trailMaterial, 
                         renderingOrder: 100, 
                         smoothen: true, 
                         fragmentShader: nil)
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
Finally, you need to enable the trail to make the effect show up.
```
trail.enabled = true
```
### Advanced Tips
- Of course, you can add a texture to the trail effect. Just add the textures to the material's properties, and things will work just like applying textures to an ordinary geometry. Note that the left edge of the image is the start of the trail and the right edge is the end. You can test the orientation yourself with some random images first.
- There is currently no way to extend the length of the trail. It always lasts five frames. You can try to connect two or more trails one after another, but I am not sure whether it will work. The reason is that currently, we can only pass up to 10 uniform attributes to a shader. Since the trail effect is created using a geometry shader, and for every frame, we need two uniform 3D vectors to store the position of the line segments, we can only keep the data of the most recent five frames. 
- You can specify a **scaleFactor** as a parameter for the trail's render function so that the generated parts of the trail will grow or shrink frame by frame.
- Disabling the trail effect does not hide it abruptly. Instead, the trail will gradually shrink towards the target node and disappear smoothly for the next few frames.
