//
//  Messier.swift
//  StarSpotterApp
//
//  Created by Gene Lee on 2/4/17.
//  Copyright © 2017 Gene Lee. All rights reserved.
//

import Foundation


struct Messier {
    let Messier: String
    let NGC: String
    let Const: String
    let RA: String
    let Dec: String
    let Desc: String
}

extension Messier {
    init?(element: NSDictionary?) {
        guard let Messier = element?.value(forKey: "Messier") as! String?,
            let NGC = element?.value(forKey: "NGC") as! String?,
        let Const = element?.value(forKey: "Const") as! String?,
        let RA = element?.value(forKey: "RA") as! String?,
        let Dec = element?.value(forKey: "Dec") as! String?,
        let Desc = element?.value(forKey: "Desc") as! String?
            else {
                return nil
        }
        
        self.Messier = Messier
        self.NGC = NGC
        self.Const = Const
        self.RA = RA
        self.Dec = Dec
        self.Desc = Desc
    }
}
