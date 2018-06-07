

import UIKit
import QuartzCore

public class SAConfettiView: UIView {

    public enum ConfettiType {
        case Confetti
        case Triangle
        case Star
        case Diamond
        case Image(UIImage)
    }

    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var intensity: Float!
    public var type: ConfettiType!
    private var active :Bool!
    var emogieImageArray = [UIImage]()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
            UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
            UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
            UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
            UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        intensity = 1
        type = .Confetti
        active = false
    }

    public func startConfetti() {
        emitter = CAEmitterLayer()

        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        
        //emitter.repeatCount = 0
        //emitter.duration = 10
        
        var cells = [CAEmitterCell]()
     
        printDebug(object: "emogi array is \(self.emogieImageArray)")
        
        printDebug(object: "emogi array count \(self.emogieImageArray.count)")
        
        
        if self.emogieImageArray.isEmpty{
            
            self.emogieImageArray = [UIImage(named: "smile 1")!,  UIImage(named: "smile 2")!,  UIImage(named: "smile 3")!,  UIImage(named: "smile 4")!,  UIImage(named: "smile 5")!,  UIImage(named: "smile 6")!,  UIImage(named: "smile 7")!,  UIImage(named: "smile 8")!]
        }
       
        for item in self.emogieImageArray{
           
            cells.append( confettiWithColor(color: UIColor.blue, image: item, speed: 2))
            
        }
        
//    
//        for item in 1...9{
//            let random = arc4random_uniform( UInt32(5))
//
//           cells.append(confettiWithColor(color: UIColor.blue, image: UIImage(named: "smile \(item)")!,speed: CGFloat(random)))
//            
//           
//        }
//        
        
        printDebug(object: "cellllll\(cells)")
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }

    public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }

    func imageForType(type: ConfettiType) -> UIImage? {

//       var fileName: String!
//
//        switch type {
//        case .Confetti:
//            fileName = "confetti"
//        case .Triangle:
//            fileName = "triangle"
//        case .Star:
//            fileName = "star"
//        case .Diamond:
//            fileName = "diamond"
//        case let .Image(customImage):
//            return customImage
//        }

//        let path = Bundle(for: SAConfettiView.self).path(forResource: "SAConfettiView", ofType: "bundle")
//        let bundle = Bundle(path: path!)
//        let imagePath = bundle?.path(forResource: fileName, ofType: "png")
//        let url = NSURL(fileURLWithPath: imagePath!)
//        let data = NSData(contentsOf: url as URL)
//        if let data = data {
//            return UIImage(data: data as Data)!
//        }
        
        let random = arc4random_uniform( UInt32(10))
        return UIImage(named: "smile \(random)")
        
      //  return nil
    }

    func confettiWithColor(color: UIColor,image:UIImage,speed:CGFloat) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 0.5 * 6
        confetti.lifetime = 3
        confetti.lifetimeRange = 0
       // confetti.color = color.withAlphaComponent(0.3).cgColor
        confetti.velocity = CGFloat(35.0 * speed)
        confetti.velocityRange = CGFloat(200.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi / 4)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
       // confetti.contents = imageForType(typ  e: type)!.cgImage
    
         if UIDevice.current.modelName == "iPhone 5" || UIDevice.current.modelName == "iPhone 5s"{
            confetti.alphaSpeed = -0.6

            printDebug(object: "5,5s")
            
         }else if UIDevice.current.modelName == "iPhone 6" || UIDevice.current.modelName == "iPhone 6s" || UIDevice.current.modelName == "iPhone 7" || UIDevice.current.modelName == "iPhone 7s" {
            
            confetti.alphaSpeed = -0.5
            
            printDebug(object: "6,6s,7,7s")

            
         }else if UIDevice.current.modelName == "iPhone 6 Plus"{
            confetti.alphaSpeed = -0.4
            printDebug(object: "6 plus")

         }
            else{
            confetti.alphaSpeed = -0.6
            printDebug(object: "other device")

        }
        
        confetti.contents = UtilClass.changeImageSize(image, CGSize(width: 25, height: 25)).cgImage
        return confetti
    }

    

    
    public func isActive() -> Bool {
    		return self.active
    }
}







