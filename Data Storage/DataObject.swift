// Developed by Kelin Lyu.
import SpriteKit
import SceneKit
class DataObject: NSObject, NSCoding {
    var ignoredVariables: [String] {
        return([])
    }
    func encode(with aCoder: NSCoder) {
        let object = Mirror(reflecting: self)
        for (_, variable) in object.children.enumerated() {
            if let name = variable.label {
                if(name != "ignoredVariables")&&(!ignoredVariables.contains(name)) {
                    aCoder.encode(variable.value, forKey: name)
                }
            }
        }
    }
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        let object = Mirror(reflecting: self)
        for (_, variable) in object.children.enumerated() {
            if let name = variable.label {
                if(name != "ignoredVariables")&&(!ignoredVariables.contains(name)) {
                    if let data = aDecoder.decodeObject(forKey: name) {
                        if(data is NSNull) {
                            self.setValue(nil, forKey: name)
                        }else{
                            self.setValue(data, forKey: name)
                        }
                    }
                }
            }
        }
    }
}
