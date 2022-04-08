# Data Storage
### Basic Usage
Suppose you want to store the player's name, best score, and other information in the cloud. With the above two modules included in your project, you only have to take three simple steps.
1. Write a class that inherits the DataObject class:
```
class PlayerData: DataObject {   
    @objc var name: String = ""
    @objc var bestScore: Int = 0
    @objc var tutorialPlayed: Bool = false
    // other variables...
}
```
2. Create an instance of your class:
```
var playerDataObject: PlayerData = PlayerData()
```
3. Perform reading and writing:
```
// read when the game launches:
if let data = DataManager.read(key: "playerDataObject", cloud: true) as? PlayerData {
    // data read successfully, so we override the current data:
    playerDataObject = data
}else{
    // the data does not exist, so this is a new player...
}

// change the data during the game:
playerDataObject.name = "Devil Otter"

// write:
DataManager.write(data: playerDataObject, key: "playerDataObject", cloud: true)
```
And that's it!
### Advanced Tips
In the first step, you must add the @objc keyword before declaring every variable.
If you have some variables in the class that you do not want to save, you must override the ignoredVariables:
```
class PlayerData: DataObject {

    // the necessary variables to store:
    @objc var name: String = ""
    @objc var bestScore: Int = 0
    @objc var tutorialPlayed: Bool = false
    // other variables...

    // inform the program about the variables you do not need to store:
    override var ignoredVariables: [String] = ["temp1", "temp2"]

    // therefore, the following variables will not be stored:
    var temp1: Int = 0
    var temp2: String = 0
}
```
You can store all the basic Swift data types directly, such as Int, Bool, String, Float, and even arrays like [Int], [[String]], etc. If you want to store objects of another class, for example, you want to save the game's map in a game like Minecraft, you need to let the map class inherit the DataObject class as well. For instance:
```
class MapBlockData: DataObject {
    @objc var type: Int = 0
    @objc var x: Int = 0
    @objc var y: Int = 0
}
class MapData: DataObject {
    @objc var blocks: [MapBlockData] = []
}
class PlayerData: DataObject {
    @objc var maps: [MapData] = []
}
```

