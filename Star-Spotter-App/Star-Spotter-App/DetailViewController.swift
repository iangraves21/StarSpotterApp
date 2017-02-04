//
//  DetailViewController.swift
//  Star-Spotter-App
//
//  Created by Kameron Haramoto on 2/4/17.
//  Copyright © 2017 Kameron Haramoto. All rights reserved.
//

import UIKit
import CoreMotion

extension UIImage {
    
    func resized(newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 50, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var ImageOutlet: UIImageView!
    let manager = CMMotionManager()
    
    var roll: Double = 0
    var pitch: Double = 0
    var yaw: Double = 0

    @IBOutlet weak var PitchOutlet: UILabel!
    @IBOutlet weak var YawOutlet: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.Desc
            }
            
            // Update the title
            self.title = detail.Messier
            
            // Display the image
            let imgWidth = UIScreen.main.bounds.size.width
            let imgHeight = imgWidth / 1.25
            let image = UIImage(named: detail.Messier + ".jpg")?.resized(newSize: CGSize(width: imgWidth, height: imgHeight))//UIImage(named: detail.Messier + ".jpg")
            ImageOutlet = UIImageView(image: image)
            ImageOutlet.contentMode = UIViewContentMode.scaleToFill
            self.view.addSubview(ImageOutlet)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        manager.deviceMotionUpdateInterval  = 0.2
        manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motionData: CMDeviceMotion?, NSError) -> Void in self.outputRPY(data: motionData!)
            if (NSError != nil){
                print("\(NSError)")
            }
        })

    }
    
    func outputRPY(data: CMDeviceMotion){
        if manager.isDeviceMotionAvailable {
            roll    = data.attitude.roll * (180.0 / M_PI)
            pitch   = data.attitude.pitch * (180.0 / M_PI)
            yaw     = data.attitude.yaw * (180.0 / M_PI)
            
            PitchOutlet.text = "Pitch: \(String(pitch))"
            YawOutlet.text = "Yaw: \(String(yaw))"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Messier? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

