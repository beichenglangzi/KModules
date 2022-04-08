# Data Storage
### Basic Usage
Suppose you want to store the player's name, highest score, and other information. With the above two modules included in your project, you only have to take three simple steps. First, create a simple class, inheriting the DataObject class:
```
class PlayerData: DataObject {   
    @objc var name: String = ""
    @objc var score: Int = 0
    @objc var tutorialPlayed: Bool = false
    // other variables...
}
```
Then, create an instance of the class:
```
var playerDataObject: PlayerData = PlayerData()
```
And finally, perform reading and writing:
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
