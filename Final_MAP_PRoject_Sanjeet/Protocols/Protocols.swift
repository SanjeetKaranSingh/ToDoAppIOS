//
//  Protocols.swift
//  Final_MAP_PRoject_Sanjeet
//
//  Created by user205584 on 12/4/21.
//

import Foundation
protocol selectedSearchResultDelegate{
    func performOperation(OnSelectedCity city:String);
}

protocol performFetchDelegate{
    func performFetchAgain()
}
