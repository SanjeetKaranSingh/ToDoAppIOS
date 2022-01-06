//
//  cityWeather.swift
//  Final_MAP_PRoject_Sanjeet
//
//  Created by user205584 on 12/4/21.
//

import Foundation
import CloudKit

struct cityWeather:Codable{
    let weather:[weather]
    let main:maintype
}

struct weather:Codable
{
    let id:Int
    let main:String
    let icon:String
}

struct maintype:Codable
{
    let temp:Float
}

