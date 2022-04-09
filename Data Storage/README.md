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

// write and save the changes:
DataManager.write(data: playerDataObject, key: "playerDataObject", cloud: true)
```
And that's it!
### Advanced Tips
- In the first step, you must add the @objc keyword before declaring every variable.
- If you have some variables in the class that you do not want to save, you must override the ignoredVariables:
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
- You can store all the basic Swift data types directly, such as Int, Bool, String, Float, and even arrays like [Int], [[String]], etc. If you want to store objects of another class, for example, you want to save the game's map in a game like Minecraft, you need to let the map class inherit the DataObject class as well. For instance:
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
- When reading the data, the first part of the if statement, DataManager.read(key, cloud), tries to retrieve the data from the destination. Then, the "as? type" part tries to convert the retrieved data to the type of your class. Therefore, you must ensure that the class name you put after the "as" keyword is consistent with the instance you create.
- If you set the cloud parameter to true in the read and write functions, the data will be saved to iCloud's key-value storage, which only has a size of 1MB. When the cloud parameter is set to false, the data will be stored locally using UserDefaults, which does not have a space limit. Note that when saving the data to the cloud, the program will also keep a local copy so that when the device loses internet connection, the data can still be read and modified.
- If you want to clear all the stored data, you can call the purge function as shown below. However, be careful that if you forget to delete such a line before releasing your game, the result will be catastrophic.
```
DataManager.purge()
```
