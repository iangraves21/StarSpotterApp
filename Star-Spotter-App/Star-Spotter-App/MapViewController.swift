//
//  MapViewController.swift
//  Star-Spotter-App
//
//  Created by Kameron Haramoto on 2/4/17.
//  Copyright © 2017 Kameron Haramoto. All rights reserved.
//

import UIKit
import CoreMotion

class MapViewController: UIViewController {

    @IBOutlet weak var currentPoint: UIImageView!
    @IBOutlet weak var targetPoint: UIImageView!
    let maxY = 656.0
    let maxX = 368.0
    var pitch: Double = 0.0
    var yaw: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPoint.image = UIImage(named: "greenDot.png")
        targetPoint.image = UIImage(named: "redDot.png:")
        targetPoint.isOpaque = true
        // Do any additional setup after loading the view.
        targetPoint.frame.origin.x = CGFloat((Globals.targetAlt / 90.0) * maxX)
        targetPoint.frame.origin.y = CGFloat((Globals.targetAz / 360.0) * maxY)
        
        manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motionData: CMDeviceMotion?, NSError) -> Void in self.outputRPY(data: motionData!)
            if (NSError != nil){
                print("\(NSError)")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func outputRPY(data: CMDeviceMotion){
        if manager.isDeviceMotionAvailable {
            pitch = data.attitude.pitch * (180.0 / M_PI)
            yaw = -1.0 * data.attitude.yaw * (180.0 / M_PI)
            let adjYaw = (adjustYaw(yaw: yaw) + Globals.yawOffset + 360).truncatingRemainder(dividingBy: 360)
            currentPoint.frame.origin.x = CGFloat((pitch / 90.0) * maxX)
            currentPoint.frame.origin.y = CGFloat((adjYaw / 360.0) * maxY)
        }
    }
    
    func adjustYaw(yaw: Double) -> Double
    {
        if(yaw < 0.0)
        {
            return 360.0 + yaw
        }
        
        return yaw
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
