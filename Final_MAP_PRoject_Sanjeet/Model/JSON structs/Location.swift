//
//  Location.swift
//  Final_MAP_PRoject_Sanjeet
//
//  Created by user205584 on 11/30/21.
//

import Foundation

struct Location:Codable
{
    init(StrsWithCityProCountFormt: [String]) {
        if(StrsWithCityProCountFormt.count == 3)
        {
            city = StrsWithCityProCountFormt[0]
            province = StrsWithCityProCountFormt[1]
            Country = StrsWithCityProCountFormt[2]
        }
        else{
            city = ""
            province = ""
            Country = ""
        }
    }
    
    let city:String
    let province:String
    let Country:String
}
