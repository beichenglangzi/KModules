// Developed by Kelin.Lyu.
import SpriteKit
import SceneKit
extension SCNVector3 {
    static var zero: SCNVector3 {
        return(SCNVector3(0))
    }
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.init(x: x, y: y, z: z)
    }
    init(_ scaler: Float) {
        self.init(scaler, scaler, scaler)
    }
    var length: Float {
        return(self <<= .zero)
    }
    var normalized: SCNVector3 {
        return(self / self.length)
    }
    var absValue: SCNVector3 {
        return(SCNVector3(abs(self.x), abs(self.y), abs(self.z)))
    }
    static func <<=(lhs: SCNVector3, rhs: SCNVector3)->(Float) {
        let dx = (lhs.x - rhs.x) * (lhs.x - rhs.x)
        let dy = (lhs.y - rhs.y) * (lhs.y - rhs.y)
        let dz = (lhs.z - rhs.z) * (lhs.z - rhs.z)
        return(Float(sqrt(dx + dy + dz)))
    }
    static func <<(lhs: SCNVector3, rhs: SCNVector3)->(Float) {
        let dx = (lhs.x - rhs.x) * (lhs.x - rhs.x)
        let dz = (lhs.z - rhs.z) * (lhs.z - rhs.z)
        return(Float(sqrt(dx + dz)))
    }
    static func *(lhs: SCNVector3, rhs: Float)->(SCNVector3) {
        return(SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs))
    }
    static func *(lhs: Float, rhs: SCNVector3)->(SCNVector3) {
        return(SCNVector3(lhs * rhs.x, lhs * rhs.y, lhs * rhs.z))
    }
    static func *=(lhs: inout SCNVector3, rhs: Float) {
        lhs = lhs * rhs
    }
    static func /(lhs: SCNVector3, rhs: Float)->(SCNVector3) {
        return(SCNVector3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs))
    }
    static func /(lhs: Float, rhs: SCNVector3)->(SCNVector3) {
        return(SCNVector3(lhs / rhs.x, lhs / rhs.y, lhs / rhs.z))
    }
    static func /=(lhs: inout SCNVector3, rhs: Float) {
        lhs = lhs / rhs
    }
    static func +(lhs: SCNVector3, rhs: SCNVector3)->(SCNVector3) {
        return(SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z))
    }
    static func +=(lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs = lhs + rhs
    }
    static func -(lhs: SCNVector3, rhs: SCNVector3)->(SCNVector3) {
        return(SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z))
    }
    static func -=(lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs = lhs - rhs
    }
    static func *(lhs: SCNVector3, rhs: SCNVector3)->(SCNVector3) {
        return(SCNVector3(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z))
    }
    static func *(lhs: SCNVector3, rhs: SCNVector3)->(Float) {
        return(lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z)
    }
    static func *=(lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs = lhs * rhs
    }
    static func /(lhs: SCNVector3, rhs: SCNVector3)->(SCNVector3) {
        return(SCNVector3(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z))
    }
    static func /=(lhs: inout SCNVector3, rhs: SCNVector3) {
        lhs = lhs / rhs
    }
    func projection(on point: SCNVector3)->(SCNVector3) {
        return(point.normalized * (self * point / point.length))
    }
}
