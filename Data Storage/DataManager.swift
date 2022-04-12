// Developed by Kelin Lyu.
import SpriteKit
import SceneKit
class DataManager {
    static func read(key: String, cloud: Bool)->(Any?) {
        if(!cloud) {
            return(DataManager.localRead(key: key))
        }
        let cloudData: Any? = DataManager.cloudRead(key: key)
        let localData: Any? = DataManager.localRead(key: key)
        var cloudSavedDate: Double = 0
        var localSavedDate: Double = 0
        if let i = DataManager.cloudRead(key: "\(key)SavedDate") as? Double {
            cloudSavedDate = i
        }
        if let i = DataManager.localRead(key: "\(key)SavedDate") as? Double {
            localSavedDate = i
        }
        if(cloudSavedDate == 0)&&(localSavedDate == 0) {
            return(cloudData)
        }
        if(cloudSavedDate >= localSavedDate) {
            return(cloudData)
        }
        return(localData)
    }
    static func write(data: Any, key: String, cloud: Bool) {
        if(!cloud) {
            DataManager.localWrite(data: data, key: key)
        }
        let date: Double = Double(Date().timeIntervalSince1970)
        DataManager.localWrite(data: data, key: key, date: date)
        DataManager.cloudWrite(data: data, key: key, date: date)
    }
    static func purge() {
        print("Purging...")
        for data in NSUbiquitousKeyValueStore.default.dictionaryRepresentation {
            print("Revmoing \(data.key)...")
            NSUbiquitousKeyValueStore.default.removeObject(forKey: data.key)
        }
        for data in UserDefaults.standard.dictionaryRepresentation() {
            print("Revmoing \(data.key)...")
            UserDefaults.standard.removeObject(forKey: data.key)
        }
    }
    static func cloudRead(key: String)->(Any?) {
        if(NSUbiquitousKeyValueStore.default.object(forKey: key) != nil) {
            if let something = NSUbiquitousKeyValueStore.default.object(forKey: key) as? Data {
                do {
                    let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(something)!
                    return(data)
                }catch{}
            }else{
                return(NSUbiquitousKeyValueStore.default.double(forKey: key))
            }
        }
        return(nil)
    }
    static func cloudWrite(data: Any, key: String, date: Double = 0) {
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            NSUbiquitousKeyValueStore.default.set(data, forKey: key)
            NSUbiquitousKeyValueStore.default.set(date, forKey: "\(key)SavedDate")
            NSUbiquitousKeyValueStore.default.synchronize()
        }catch{}
    }
    static func localRead(key: String)->(Any?) {
        if(UserDefaults.standard.object(forKey: key) != nil) {
            if let something = UserDefaults.standard.object(forKey: key) as? Data {
                do {
                    let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(something)!
                    return(data)
                }catch{}
            }else{
                return(UserDefaults.standard.double(forKey: key))
            }
        }
        return(nil)
    }
    static func localWrite(data: Any, key: String, date: Double = 0) {
        do {
            let data: Data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: key)
            UserDefaults.standard.set(date, forKey: "\(key)SavedDate")
            UserDefaults.standard.synchronize()
        }catch{}
    }
}
