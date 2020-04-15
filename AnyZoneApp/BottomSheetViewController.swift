//
//  BottomViewController.swift
//  AnyZoneApp
//
//  Created by Anıl Taşkıran on 23.06.2019.
//  Copyright © 2019 Creabbit. All rights reserved.
//

import UIKit

extension BottomSheetViewController {
    
    private enum State {
        case partial
        case full
    }
    
    private enum Constant {
        static let fullViewYPosition: CGFloat = 0
        static var partialViewYPosition: CGFloat { UIScreen.main.bounds.height - 160 }
    }
}

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    var midViewX = CGFloat()
    var midViewY = CGFloat()
    var shapeLayer2 = CALayer()
    var shapeLayer3 = CALayer()
    var shapeLayer4 = CALayer()
    var shapeLayer1 = CALayer()
    
    
    @IBOutlet weak var viewProcess: UIView!
    var options = ProcessOptions()
    let step = 2
    let totalSteps = 4
    
    let colorBlue = UIColor(displayP3Red: 100/255, green: 217/255, blue: 213/255, alpha: 1)
    let colorOrange = UIColor(displayP3Red: 191/255, green: 155/255, blue: 124/255, alpha: 1)
    
    let bgColor = UIColor.clear
    
    
    var first:CGFloat = 315.0
    var second:CGFloat = 360.0
    var third:CGFloat = 45.0
    var alphaValue:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        options.images = imageOpts(of: 2, totalSteps: 4)
        
        midViewX = viewProcess.frame.midX
        midViewY = viewProcess.frame.midY
        drawInitialCircleView()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
        roundViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: {
            self.moveView(state: .partial)
        })
    }
    
}

// MARK: Gesture Mehtods
extension BottomSheetViewController {
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        
        let minY = view.frame.minY
        let velocity = recognizer.velocity(in: view)
        
        let translation = recognizer.translation(in: view)
        
        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }
    
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {
                let state: State = recognizer.velocity(in: self.view).y >= 0 ? .partial : .full
                if state == .full {
                    var xy = self.getXY(angle: Double(360))
                    self.shapeLayer2.position = CGPoint(x: xy.0, y: xy.1)
                    xy = self.getXY(angle: Double(90))
                    self.shapeLayer3.position = CGPoint(x: xy.0, y: xy.1)
                    
                    xy = self.getXY(angle: Double(180))
                    self.shapeLayer4.position = CGPoint(x: xy.0, y: xy.1)
                    
                } else {
                    var xy = self.getXY(angle: Double(315))
                    self.shapeLayer2.position = CGPoint(x: xy.0, y: xy.1)
                    xy = self.getXY(angle: Double(360))
                    self.shapeLayer3.position = CGPoint(x: xy.0, y: xy.1)
                    xy = self.getXY(angle: Double(45))
                    self.shapeLayer4.position = CGPoint(x: xy.0, y: xy.1)
                }
                //self.resetValue()
                self.moveView(state: state)
            }, completion: nil)
        }
    }
    
}

extension BottomSheetViewController {
    
    private func drawInitialCircleView() {
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: midViewX,y: midViewY), radius: CGFloat(120), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1.0
        view.layer.addSublayer(shapeLayer)
        
        var xy = getXY(angle: 270)
        shapeLayer1 = circleShape(imgOpt: options.images[0])
        shapeLayer1.position = CGPoint(x: xy.0, y: xy.1)
        view.layer.addSublayer(shapeLayer1)
        
        xy = getXY(angle: 315)
        shapeLayer2 = circleShape(imgOpt: options.images[1])
        shapeLayer2.position = CGPoint(x: xy.0, y: xy.1)
        view.layer.addSublayer(shapeLayer2)
        
        xy = getXY(angle: 360)
        shapeLayer3 = circleShape(imgOpt: options.images[2])
        shapeLayer3.position = CGPoint(x: xy.0, y: xy.1)
        view.layer.addSublayer(shapeLayer3)
        
        xy = getXY(angle: 45)
        shapeLayer4 = circleShape(imgOpt: options.images[3])
        shapeLayer4.position = CGPoint(x: xy.0, y: xy.1)
        view.layer.addSublayer(shapeLayer4)
    }
    private func resetValue() {
        first = 315.0
        second = 360.0
        third = 45.0
        alphaValue = 0.0
    }
    
    func roundViews() {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    func getXY(angle: Double) -> (CGFloat, CGFloat) {
        let angleEarth: Double = angle
        let angleEarthAfterCalculate: CGFloat = CGFloat(angleEarth*M_PI/180) - CGFloat(M_PI/2)
        let earthX = midViewX + cos(angleEarthAfterCalculate)*120
        let earthY = midViewY + sin(angleEarthAfterCalculate)*120
        return (earthX,earthY)
    }
    
    func circleShape(imgOpt:(UIImage, UIColor?))->CALayer {
        let imageSize: CGFloat = 30 - 6
        var viewRect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let view = UIView(frame: viewRect)
        view.backgroundColor = .orange
        view.layer.cornerRadius = 30/2
        
        viewRect.size.width = imageSize
        viewRect.size.height = imageSize
        
        let imgV = UIImageView(frame: viewRect)
        var image:UIImage!
        if let color = imgOpt.1
        {
            image = imgOpt.0.withRenderingMode(.alwaysTemplate)
            //imgV.tintColor = color
        }
        else
        {
            image = imgOpt.0
        }
        imgV.tintColor = .clear
        image = imgOpt.0
        imgV.image = image
        imgV.layer.cornerRadius = imageSize / 2
        imgV.center = view.center
        view.layer.addSublayer(imgV.layer)
        
        return view.layer
    }
    
    func imageOpts(of stepNumber:Int, totalSteps:Int) ->[(UIImage, UIColor?)] {
        
        let image: UIImage = UIImage(named: "food_circle") ?? UIImage()
        let image1: UIImage = UIImage(named: "restaurant_circle") ?? UIImage()
        let image2: UIImage = UIImage(named: "rider_cycle") ?? UIImage()
        let image3: UIImage = UIImage(named: "headPhone_circle") ?? UIImage()
        var optsImages = [(UIImage, UIColor?)]()
        if stepNumber > 4 {
            // optsImages.append((image, colorBlue))
        }
        
        for i in 0  ..< totalSteps {
            if stepNumber > i {
                optsImages.append((image, colorBlue))
            } else if stepNumber == i {
                optsImages.append((image1, colorOrange))
            } else {
                //optsImages.append((image2, UIColor.gray))
                optsImages.append((image3, UIColor.gray))
            }
        }
        return optsImages
    }
    
}
