//
//  DatabaseHandler.swift
//  WeatherDemoApp
//
//   Created by prashanthi M on 01/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import UIKit
import CoreData

class DatabaseHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext{
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           return appDelegate.persistentContainer.viewContext
       }
       
    class func saveObject(cityName: String,cityTimeZone: String,cityTemp: String,humudity:String,pressure:String,speed:String,country:String) {
           
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           let weatherContent = WeatherData(context: context)
           
           weatherContent.cityName = cityName
           weatherContent.cityTimeZone = cityTimeZone
           weatherContent.cityTemp = cityTemp
           weatherContent.humudity = humudity
           weatherContent.country = country
           weatherContent.pressure = pressure
           weatherContent.speed = speed
           do {
               try context.save()
           } catch {
               // Replace this implementation with code to handle the error appropriately.
               // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               let nserror = error as NSError
               fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
           }
       }
       
       static func fetchedWeatherData() ->  [WeatherData] {
           
           var items = [WeatherData]()
           
           //query = select* rom events
           let fetchRequest: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
        
           do {
               
               let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
               items = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [WeatherData]
           } catch {
               fatalError("Failed to fetch itemList: \(error)")
           }
           return items
       }
    
    static func deleteWeatherData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var items = [WeatherData]()
        let fetchRequest: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "cityName = %@", cityName)
        
        do {
            items = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [WeatherData]
        } catch {
            fatalError("Failed to fetch itemList: \(error)")
        }
        
        
        if items.count != 0{
            
            let managedObject = items[0]
            context.delete(managedObject)
            
            // Save the context.
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }
    }
    
    static func checkCityExist(cityName: String) -> Int{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var items = [WeatherData]()
        let fetchRequest: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityName = %@", cityName)
        //request.fetchLimit = 1
        
        do{
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                // print("no matching object")
                return 0
                // no matching object
            }
            else {
                // print("at least one matching object exists")
                return 1
            }
        }
        catch let error as NSError {
            // print("Could not fetch \(error), \(error.userInfo)")
        }
        return 0
    }
    
    
}
