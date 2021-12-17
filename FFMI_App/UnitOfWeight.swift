//
//  UnitOfWeight.swift
//  FFMI_App
//
//  Created by 蔡尚諺 on 2021/12/13.
// kg = 公斤 , lb = 磅

import Foundation

enum UnitOfWeight: String  {
case kg = "kg" , lb = "lb"
    
    func getUnit() -> UnitMass {
        var unitMass: UnitMass
        
        
        switch self {
        case .kg:
            unitMass = UnitMass.kilograms
        case .lb:
            unitMass = UnitMass.pounds
        }
        
        return unitMass
    }
}
