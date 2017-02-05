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
    
    func resized(newSize:CGSize, xpos: CGFloat = 0, ypos: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: xpos, y: ypos, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var CurrentLabelOutlet: UILabel!
    var ImageOutlet: UIImageView!
    
    var roll: Double = 0
    var pitch: Double = 0
    var yaw: Double = 0
    var yawDiffOffset: Double = 0
    var alt: Double = 0
    var az: Double = 0

    @IBOutlet weak var AltOutlet: UILabel!
    @IBOutlet weak var AzOutlet: UILabel!
    
    // Current => Phones
    @IBOutlet weak var PitchOutlet: UILabel!
    @IBOutlet weak var YawOutlet: UILabel!
    
    @IBOutlet weak var CalibrateButtonOutlet: UIButton!
    @IBAction func CalibrateTapped(_ sender: UIButton) {
        yaw = 0
        yawDiffOffset = yaw - az
    }
    
    @IBOutlet weak var ResetButtonOutlet: UIButton!
    @IBAction func ResetTapped(_ sender: UIButton) {
        yawDiffOffset = 0
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.Desc
                (alt, az) = detail.altAz(lat: 46.729777, long: -117.181738)
                AltOutlet.text = "Alt: \(alt) degrees"
                AzOutlet.text = "Az: \(az) degrees"
            }
            
            // Update the title
            self.title = detail.Messier
            
            // Display the image
            let imgWidth = UIScreen.main.bounds.size.width
            let imgHeight = imgWidth / 1.25
            let image = UIImage(named: detail.Messier + ".jpg")?.resized(newSize: CGSize(width: imgWidth, height: imgHeight), ypos: 50)//UIImage(named: detail.Messier + ".jpg")
            ImageOutlet = UIImageView(image: image)
            ImageOutlet.contentMode = UIViewContentMode.scaleToFill
            self.view.addSubview(ImageOutlet)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        manager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motionData: CMDeviceMotion?, NSError) -> Void in self.outputRPY(data: motionData!)
            if (NSError != nil){
                print("\(NSError)")
            }
        })

    }
    
    
    func outputRPY(data: CMDeviceMotion){
        if let detail = self.detailItem {
            if detail.isVisible(lat: 46.729777, long: -117.181738) {
                CurrentLabelOutlet.text = "Current"
                if manager.isDeviceMotionAvailable {
                    roll    = data.attitude.roll * (180.0 / M_PI)
                    pitch   = data.attitude.pitch * (180.0 / M_PI)
                    yaw     = data.attitude.yaw * (180.0 / M_PI) + yawDiffOffset
                    
                    PitchOutlet.text = "Alt: \(String(pitch)) degrees"
                    YawOutlet.text = "Az: \(String(yaw)) degrees"
                }
            }
            else {
                CurrentLabelOutlet.text = "Not visible"
                PitchOutlet.isHidden = true
                YawOutlet.isHidden = true
                CalibrateButtonOutlet.isHidden = true
                ResetButtonOutlet.isHidden = true
            }
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

