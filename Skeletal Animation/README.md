# Skeletal Animation
### Design
This is one of the most complex but helpful modules I have developed. Before I created this module, I used the **SCNAnimationPlayer**, which works, but it is hard to control (you will see what I mean), and the transitions do not look very nice. Therefore, I decided to design my own modules. 

The basic idea is to have two classes named **Model** and **Animation**. The **Model** class inherits **SCNNode** and is responsible for loading a rigged model and controlling all the **Animation** objects attached to it. It is always a good idea to isolate the animations. For example, when making characters, I always add the **Model** node as a child node to a control node. The **Model** node only handles animations, while the control node handles movements, physics, and other logic. 

There is nothing special about the **Animation** class: it loads a single animation and updates every frame, controlled by a **Model** object. Note that this module requires you to be familiar with modeling software like Maya because first, you have to make sure that the skeleton of the rigged model is the same as that of the animations. Otherwise, it will not work. Second, the **Animation** class cannot trim the animations, so you have to edit that by yourself.
### Basic Usage
To test this module for the first time, you are recommended to download models and animations from the Mixamo platform. First, you need to download a static T-pose model and an animation for that model. Both files should be in the DAE format. Then, create a new iOS game project with SceneKit technology in Swift. Next, drag the model and the animation files into the SceneKit assets folder (art.scnassets). Finally, we need to convert the model to the SCN format (the animations remain to be DAE files). Open the static model in the Xcode editor and drag a single cube into the scene from the Media Manager (if you cannot find it, then in the menu bar, try View - Show Library). The Xcode will ask whether you want to convert the DAE file to the SCN format. Click convert, and now you have a new model file in the SCN format. Delete the cube if it is created by mistake since we do not need it anyway.

Now, let's try to load and display the model. First, create a global variable of type **Model**:
```
var model: Model!
```
Then, in the place where you initialize the **SCNScene** (in the **viewDidLoad** function if you are creating a new project), load the SCN file:
```
model = Model(file: "art.scnassets/???", scale: 1)
// replace the ??? with the name of your model file without the scn extension!

scene.rootNode.addChildNode(model)
```
Then, you need to implement the **updateAtTime** function, one of the renderer functions of the **SCNSceneRendererDelegate** protocol, and there, you need to call the update function of the model:
```
model?.update(at: time)
```
Now, run the project. You should see the static model somewhere on the screen. If the model is too large or small, adjust the **scale** parameter when constructing the **Model** object.
### Advanced Tips
