# Data Storage
### Basic Usage
Suppose you want to store the player's name, highest score, and other information. With the above two modules included in your project, you only have to take three simple steps.
1. Write a class that inherits the DataObject class:
```
class PlayerData: DataObject {   
    @objc var name: String = ""
    @objc var score: Int = 0
    @objc var tutorialPlayed: Bool = false
    // other variables...
}
```
2. Create an instance of your class:
```
var playerDataObject: PlayerData = PlayerData()
```
3. Perform reading and writing whenever you want:
```
// read:
if let data = DataManager.read(key: "playerDataObject", cloud: true) as? PlayerData {
    // data read successfully, so we override the current data:
    playerDataObject = data
}else{
    // the data does not exist, so this is a new player...
}

// write:
DataManager.write(data: playerDataObject, key: "playerDataObject", cloud: true)
```
And that's it!
### Explanations
