# Skeletal Animation
### Design
This is one of the most complex but helpful modules I have developed. Before I created this module, I used the **SCNAnimationPlayer**, which works, but it is hard to control (you will see what I mean), and the transitions do not look very nice. Therefore, I decided to design my own modules. 

The basic idea is to have two classes named **Model** and **Animation**. The **Model** class inherits **SCNNode** and is responsible for loading a rigged model and controlling all the **Animation** objects attached to it. It is always a good idea to isolate the animations. For example, when making characters, I always add the **Model** node as a child node to a control node. The **Model** node only handles animations, while the control node handles movements, physics, and other logic. 

There is nothing special about the **Animation** class: it loads a single animation and updates its behavior every frame, controlled by a **Model** object. Every animation can be defined as continuous or non-continuous, which determines its update behavior.

Note that this module requires you to be familiar with modeling software like Maya because first, you have to make sure that the skeleton of the rigged model is the same as that of the animations. Otherwise, it will not work. Second, the **Animation** class cannot trim the animations, so you have to edit that by yourself.
### Basic Usage
To test this module for the first time, you are recommended to download models and animations from the Mixamo platform. First, you need to download a static T-pose model and an animation for that model. Both files should be in the DAE format. Then, create a new iOS game project with SceneKit technology in Swift. Next, drag the model and the animation files into the SceneKit assets folder (art.scnassets). Finally, we need to convert the model to the SCN format (the animations remain to be DAE files). Open the static model in the Xcode editor and drag a single cube into the scene from the Media Manager (if you cannot find it, then in the menu bar, try View - Show Library). The Xcode will ask whether you want to convert the DAE file to the SCN format. Click convert, and now you have a new model file in the SCN format. Delete the cube if it is created by mistake since we do not need it anyway.

Build the project. If Xcode gives you a warning that the DAE file cannot be copied, you should check Xcode's Preference - Locations and ensure that the Command Line Tools is not empty. If the problem persists, you should stop reading this tutorial and delete the newly created project as soon as possible.

Now, let's try to load and display the model. First, create a global variable of type **Model** for demonstration:
```
var model: Model!
```
Then, in the place where you initialize the **SCNScene** (in the **viewDidLoad** function if you are creating a new project), load the SCN file:
```
// replace the ??? with the name of your model file without the scn extension:
model = Model(file: "art.scnassets/???", scale: 1)

scene.rootNode.addChildNode(model)
```
Then, you need to implement the **updateAtTime** function, one of the renderer functions of the **SCNSceneRendererDelegate** protocol, and there, you need to call the update function of the model:
```
model?.update(at: time)
```
Now, run the project. You should see the static model somewhere on the screen. If the model is too large or small, adjust the **scale** parameter when constructing the **Model** object.

Next, let's load the animation you prepared. Right after you add the **Model** object to the scene, write:
```
// replace the ??? with the name of your animation file without the dae extension:
model.add(animation: "test", 
          file: "art.scnassets/???", 
          continuous: true, 
          speed: 1, 
          blendFactor: 1, 
          fadeInDuration: 0, 
          fadeOutDuration: 0, 
          events: [], 
          remove: false,
          useLoadedAnimation: true)
```
Here are the descriptions of the parameters:
- animation: the unique name of the animation.
- file: the path of the DAE file without the extension.
- continuous: a boolean indicating whether the animation is continuous. If it is, then after you start the animation, it will keep playing until you tell it to stop. Otherwise, it will stop when the animation finishes. For example, idle and running animations should be continuous, and attacking animations should not.
- speed: the speed of the animation.
- blendFactor: the blend factor of the animation. The animation will influence the rigged model less if the blend factor is smaller than one.
- fadeInDuration: the fade-in duration when the animation starts.
- fadeOutDuration: the fade-out duration when the animation stops.
- events: an array of **SCNAnimationEvent**s. The event blocks will be automatically called at the animation's designated timestamps, useful for adding footsteps and other effects.
- remove: if set to true, the animation is removed after it stops playing. Otherwise, it clamps to the last frame, which is convenient for death animations. Note that it only works when the animation is non-continuous.
- useLoadedAnimation: when set to true, the animation will only be loaded once. The next time you load the animation for a clone of the same character or a different character, the first animation is simply copied, reducing the time for loading. However, this will also bind the copied animations with the original ones, which means that their speed and time will always be the same.

After that, you can simply play or stop the animation:
```
model.play(animation: "test")
//model.stop(animation: "test")
```
### Advanced Tips
- Never forget to call the update function!
- Make sure that the structure of the bones is the same for the rigged model and the animations. Also, make sure that there are no irrelevant nodes or animations in the animation files. This is because the module might load the irrelevant one before locating the real one.
- The order of calling the **add** function of the **Model** object matters. The newly added animations override the ones you loaded before. Therefore, in most cases, you should load movement animations after the idle animations and all the non-continuous animations after the continuous ones. The animations that clamp should be added last.
- If you want an animation to blend on top of other animations, make sure that there are at least two keyframes for the bones. The first keyframe should be at the start, and the other should be at the end of the animation. If you want to achieve animation masking, for example, the character runs while playing the attacking animation, make sure that the attacking animation does not have any keyframes on the bones on the character's legs, hip, and waist. And for all other bones, there should be at least two keyframes as specified above.
- To avoid loading the same model over and over, you can first load the SCN file to a **SCNNode**, and call another constructor of the **Model** class that copies the node instead of reading the file. However, these models will share the same geometry and materials (you can unshare them manually by recursively reading all its child nodes and copying the geometries and materials).
```
let node: SCNNode = SCNNode()
if let scene = SCNScene(named: "art.scnassets/???.scn") {
    for n in scene.rootNode.childNodes {
        node.addChildNode(n)
    }
}

let model1: Model = Model(node: node, scale: 1)
let model2: Model = Model(node: node, scale: 1)
```
- For the **play** and **stop** functions of the **Model** class, you can specify a new fade-in or fade-out duration, speed, and blend factor using the optional parameters.
- There are other helper methods in the **Model** class:
```
// get the animation with a given name:
if let animation = model.get(animation: "test") {
    // access the animation's variables...
}

// stop all the animations playing unless the name of the animation is on the list:
model.stopAllAnimations(except: ["test"])
```
- When a **Model** object is no longer needed, call its **destroy** method:
```
// free up the memory of the model and all of its animations:
model.destroy()
```
- Given an **Animation** object, you can access its **state**, which has four possible cases: **.off**, **.turningOn**, **.on**, and **.turningOff**. You can also access its duration, speed, blend factor, etc. You are not recommended to overwrite the values of these variables.
