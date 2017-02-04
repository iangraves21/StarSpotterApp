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
    
    func altAz(lat: Double, long: Double) -> (Double, Double)
    {
        let rah = Double(RA[RA.startIndex...RA.index(RA.startIndex, offsetBy: 1)])
        let ram = Double(RA[RA.index(RA.startIndex, offsetBy: 2)...RA.index(RA.startIndex, offsetBy: 3)])
        let ras = Double(RA[RA.index(RA.startIndex, offsetBy: 4)...RA.index(RA.startIndex, offsetBy: 5)])
        let dech = Double(Dec[Dec.startIndex...Dec.index(Dec.startIndex, offsetBy: 2)])
        let decm = Double(Dec[Dec.index(RA.startIndex, offsetBy: 3)...Dec.index(Dec.startIndex, offsetBy: 4)])
        let decs = Double(Dec[Dec.index(RA.startIndex, offsetBy: 5)...Dec.index(Dec.startIndex, offsetBy: 6)])
        let ra = (rah! + ram!/60 + ras!/3600) * 15
        let conv = (dech! < 0.0) ? -decm!/60 - decs!/3600 : decm!/60 + decs!/3600
        let dec = dech! + conv
        
        print(ra)
        print(dec)
        
        let rad = M_PI/180
        let J2000 = 2451545.0
        let seconds = 86400.0
        let currentJulian = NSDate().timeIntervalSince1970 / seconds - 0.5 + 2440588.0
        print(currentJulian)
        let interval = currentJulian - J2000
        print(interval)
        let sidereal = (rad) * (280.16 + 360.9856235 * interval) - long * rad
        print(sidereal)
        let HA = (sidereal - ra + 360).truncatingRemainder(dividingBy: 360)
        print(HA)
        
        // Final Angle Calculations
        let x = cos(HA * rad) * cos(dec * rad)
        let y = sin(HA * rad) * cos(dec * rad)
        let z = sin(dec * rad)
        
        let x2 = x * cos((90 - lat) * rad) - z * sin((90 - lat) * rad)
        let z2 = x * sin((90 - lat) * rad) + z * cos((90 - lat) * rad)
        
        let alt = asin(z2)/rad
        let az = atan2(y, x2)/rad + 180
//        let UT = NSDate().
//        let LST = (100.46 + 0.985647 * interval + long + 15 * UT + 360) % 360
        print(alt)
        print(az)
        
        return (alt, az)
        
    }
    
    func getAltAz(lat: Double, long: Double) -> (String, String)
    {
        let ret = altAz(lat: lat, long: long)
        
        let alt = "Alt: " + String(ret.0) + " degrees"
        let az = "Az: " + String(ret.1) + " degrees"
        
        return (alt, az)
    }
    
    func isVisible(lat:Double, long: Double) -> Bool
    {
        let alt = altAz(lat: lat, long: long).0
        return alt > 0.0
    }
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
