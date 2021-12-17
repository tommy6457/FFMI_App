//
//  UnitOfLength.swift
//  FFMI_App
//
//  Created by 蔡尚諺 on 2021/12/13.
//cm = 公分 , m = 公尺 , feet = 英呎

import Foundation

enum UnitOfLength: String  {
    case cm = "cm" , m = "m" , feet = "feet"
    
    func getUnit() -> UnitLength  {
        
        var unitLength: UnitLength
        
        switch self {
        case .cm:
            unitLength = UnitLength.centimeters
        case .m:
            unitLength = UnitLength.meters
        case .feet:
            unitLength = UnitLength.feet
        }
        
        return unitLength
    }
}
