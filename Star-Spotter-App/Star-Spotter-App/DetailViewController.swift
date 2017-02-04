//
//  DetailViewController.swift
//  Star-Spotter-App
//
//  Created by Kameron Haramoto on 2/4/17.
//  Copyright © 2017 Kameron Haramoto. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.Desc
                detail.getAltAz(lat: 46.729777, long: -117.181738)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
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

