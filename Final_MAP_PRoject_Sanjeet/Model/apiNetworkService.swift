//
//  apiNetworkService.swift
//  Final_MAP_PRoject_Sanjeet
//
//  Created by user205584 on 11/29/21.
//

import Foundation
class apiNetworkService
{
    // MARK: - singleton code
    static let shared = apiNetworkService()    // Singleton to enforce all objects to point to same object
    
    private init(){
        // Private so that it can enforce use of singleton
    }
    
    // MARK: - http request for rest api
    func getDataFromURL(AtURL url:URL, complitionHander: @escaping (Data)->Void){
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else {
                return
            }
            
            complitionHander(data)
        }.resume()
    }
}
