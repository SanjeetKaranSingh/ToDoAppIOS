//
//  AddCitiesModelController.swift
//  Final_MAP_PRoject_Sanjeet
//
//  Created by user205584 on 11/30/21.
//

import Foundation
import CoreData
import UIKit
class ModelController{
    static let shared = ModelController()
    private init(){}
    let cityNameBaseURL = "http://gd.geobytes.com/AutoCompleteCity"
    
    func getListOfLocations(withStrInCityName content:String, complitionHandler:@escaping ([Location]) -> Void)
    {
        if content.isEmpty
        {
            return
        }
        var urlcomponents = URLComponents(string: cityNameBaseURL)
        urlcomponents?.queryItems = ["q":content,].map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        if let url = urlcomponents?.url {
            apiNetworkService.shared.getDataFromURL(AtURL: url) { data in
                let jsonDecoder = JSONDecoder()
                let result = try?jsonDecoder.decode([String].self, from: data)
                if let result = result{
                    complitionHandler(
                        result.map {
                        Location(StrsWithCityProCountFormt: $0.components(separatedBy: ","))
                    })
                }
            }
        }
    }
    func PerformActionsOnselectedACity(City:String){
        
    }
    
    func add(cityWithname:String) -> City
    {
        var city:City
        if let fetchedCity = fetchcity(withName: cityWithname){
            city = fetchedCity
        }
        else{
            city  = City(context: CoreDataStack.shared.persistentContainer.viewContext)
            city.name = cityWithname
        }
        return city
    }
    
    func add(Todo: ToDo, withCity cityWithname:String)
    {
        
        var city:City
        if let fetchedCity = fetchcity(withName: cityWithname){
            city = fetchedCity
        }
        else{
            city  = City(context: CoreDataStack.shared.persistentContainer.viewContext)
            city.name = cityWithname
        }
        Todo.city = city
        city.addToTodo(Todo)
    }
    
    func fetchcity(withName name:String) -> City?{
        let fetch:NSFetchRequest<City> = City.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetch.predicate = NSPredicate(format: "name = %@", name)
        let fetchedResult = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(fetch) as [City]
        if let fetchedResult = fetchedResult{
        if checkIf(thisIndex: 0, exsitsIn: fetchedResult){
            return fetchedResult[0]
        }
        }
        return nil
    }
    
    func checkIf<T>(thisIndex index:Int, exsitsIn collection:[T]) -> Bool{
        if collection.count < index + 1{
            return false
        }
        else{
            return true
        }
    }
    func getAllToDOs(ForCity city:String) -> [ToDo]?
    {
        let fetchRequest:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "city.name = %@", city)
        let resultedToDoArray = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(fetchRequest) as [ToDo]
        return resultedToDoArray
    }

    func delete(Todo:ToDo){
        CoreDataStack.shared.persistentContainer.viewContext.delete(Todo)
        CoreDataStack.shared.saveContext()
    }
    func delete(city: City){
        CoreDataStack.shared.persistentContainer.viewContext.delete(city)
        CoreDataStack.shared.saveContext()
    }
    //Doing
}
