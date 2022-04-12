// Developed by Kelin Lyu.
import SpriteKit
import SceneKit
enum AnimationState {
    case off
    case turningOn
    case on
    case turningOff
}
class Animation {
    static var loadedAnimations: [String : SCNAnimationPlayer] = [:]
    var model: Model!
    var animation: SCNAnimationPlayer!
    var name: String = ""
    var continuous: Bool = true
    var state: AnimationState = .off
    var speed: CGFloat = 1
    var speedFactor: CGFloat = 1
    var currentBlendFactor: CGFloat = 0
    var maxBlendFactor:CGFloat = 1
    var fadeInDuration: CGFloat = 0
    var fadeOutDuration: CGFloat = 0
    var events: [SCNAnimationEvent] = []
    var remove: Bool = true
    var duration: TimeInterval = 0
    var phaseChangeTime: TimeInterval?
    var phaseChangeBlendFactor: CGFloat = 0
    var temporaryFadeInDuration: CGFloat?
    var temporaryFadeOutDuration: CGFloat?
    init(name: String, file: String, continuous: Bool,
         speed: CGFloat, blendFactor: CGFloat,
         fadeInDuration: CGFloat, fadeOutDuration: CGFloat,
         events: [SCNAnimationEvent], remove: Bool,
         model: Model, useLoadedAnimation: Bool = false) {
        self.name = name
        self.continuous = continuous
        self.speed = speed
        self.maxBlendFactor = blendFactor
        self.fadeInDuration = fadeInDuration
        self.fadeOutDuration = fadeOutDuration
        self.events = events
        self.remove = remove
        self.model = model
        var requireLoadingFile: Bool = true
        if(useLoadedAnimation) {
            for data in Animation.loadedAnimations {
                if(data.key == file) {
                    self.animation = (data.value.copy() as! SCNAnimationPlayer)
                    requireLoadingFile = false
                }
            }
        }
        if(requireLoadingFile) {
            self.animation = SCNAnimationPlayer(load: file)
            self.animation.animation.usesSceneTimeBase = false
            self.animation.animation.blendInDuration = 0
            self.animation.animation.blendOutDuration = 0
            if(self.continuous) {
                self.animation.animation.isRemovedOnCompletion = false
                self.animation.animation.repeatCount = CGFloat.greatestFiniteMagnitude
            }else{
                self.animation.animation.isRemovedOnCompletion = self.remove
                self.animation.animation.repeatCount = 1
            }
            self.animation.animation.animationEvents = self.events
            if(useLoadedAnimation) {
                let newAnimation = self.animation.copy() as! SCNAnimationPlayer
                Animation.loadedAnimations[file] = newAnimation
            }
        }
        if(!self.continuous)&&(remove) {
            self.duration = self.animation.animation.duration
        }else{
            self.duration = TimeInterval.greatestFiniteMagnitude
        }
        if(self.continuous) {
            self.model.addAnimationPlayer(self.animation, forKey: self.name)
            self.animation.stop()
        }
    }
    func play(fadeInDuration temporaryFadeInDuration: CGFloat? = nil,
              newSpeed: CGFloat? = nil, newBlendFactor: CGFloat? = nil) {
        if(self.state == .turningOn)||(self.state == .on) {
            return
        }
        if(self.remove)&&(self.state == .turningOff) {
            return
        }
        if let d = temporaryFadeInDuration {
            self.temporaryFadeInDuration = d
        }else{
            self.temporaryFadeInDuration = nil
        }
        if let speed = newSpeed {
            self.speed = speed
            self.animation.speed = self.speed * self.speedFactor
        }
        if let blendFactor = newBlendFactor {
            self.maxBlendFactor = blendFactor
        }
        if(self.state == .off) {
            self.currentBlendFactor = 0
            self.animation.blendFactor = 0
            if(self.continuous) {
                self.animation.play()
            }else{
                self.model.addAnimationPlayer(self.animation, forKey: self.name)
                self.animation.play()
            }
        }
        self.state = .turningOn
        self.phaseChangeTime = nil
        self.phaseChangeBlendFactor = self.currentBlendFactor
    }
    func stop(fadeOutDuration temporaryFadeOutDuration: CGFloat? = nil) {
        if(self.state == .turningOn)||(self.state == .on) {
            if let d = temporaryFadeOutDuration {
                self.temporaryFadeOutDuration = d
            }else{
                self.temporaryFadeOutDuration = nil
            }
            self.temporaryFadeInDuration = nil
            self.phaseChangeTime = nil
            self.state = .turningOff
        }
    }
    func fadeInFunction(time: TimeInterval)->(CGFloat) {
        var fadeDuration: CGFloat = self.fadeInDuration
        if let d = self.temporaryFadeInDuration {
            fadeDuration = d
        }
        let x: CGFloat = CGFloat.pi * CGFloat(time) / (fadeDuration / (self.speed * self.speedFactor))
        let value: CGFloat = (-cos(x) + 1) * 0.5 * (1 - self.phaseChangeBlendFactor)
        return(value + self.phaseChangeBlendFactor)
    }
    func fadeOutFunction(time: TimeInterval)->(CGFloat) {
        var fadeDuration: CGFloat = self.fadeOutDuration
        if let d = self.temporaryFadeOutDuration {
            fadeDuration = d
        }
        let x: CGFloat = CGFloat.pi * CGFloat(time) / (fadeDuration / (self.speed * self.speedFactor))
        let value: CGFloat = (cos(x) + 1) * 0.5
        return(value * self.phaseChangeBlendFactor)
    }
    func update(at time: TimeInterval) {
        if(self.state == .off) {
            return
        }
        var progress: TimeInterval = 0
        if let t = self.phaseChangeTime {
            progress = time - t
        }else{
            self.phaseChangeTime = time
            self.phaseChangeBlendFactor = self.currentBlendFactor
        }
        if(self.state == .turningOn) {
            self.currentBlendFactor = fadeInFunction(time: progress)
            var fadeDuration: CGFloat = self.fadeInDuration
            if let d = self.temporaryFadeInDuration {
                fadeDuration = d
            }
            if(CGFloat(progress) >= (fadeDuration / (self.speed * self.speedFactor))) {
                self.currentBlendFactor = 1
                self.state = .on
            }
        }else if(self.state == .turningOff) {
            self.currentBlendFactor = fadeOutFunction(time: progress)
            var fadeDuration: CGFloat = self.fadeOutDuration
            if let d = self.temporaryFadeOutDuration {
                fadeDuration = d
            }
            if(CGFloat(progress) >= (fadeDuration / (self.speed * self.speedFactor))) {
                self.currentBlendFactor = 0
                self.state = .off
                if(self.continuous) {
                    self.animation.stop()
                }else{
                    self.model.removeAnimation(forKey: name)
                }
            }
        }
        if(self.state == .turningOn)||(self.state == .on) {
            if(self.remove) {
                let maxProgress: TimeInterval = self.duration - TimeInterval(self.fadeOutDuration)
                if(progress > maxProgress / TimeInterval(self.speed * self.speedFactor)) {
                    self.stop()
                }
            }
        }
        self.animation.speed = self.speed * self.speedFactor
        self.animation.blendFactor = self.currentBlendFactor * self.maxBlendFactor
    }
    func destroy() {
        self.state = .off
        self.model = nil
        self.animation = nil
        self.events.removeAll()
        self.phaseChangeTime = nil
        self.temporaryFadeInDuration = nil
        self.temporaryFadeOutDuration = nil
    }
}
