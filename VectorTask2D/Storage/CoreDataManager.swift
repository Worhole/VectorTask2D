//
//  StorageManager.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-24.
//

import Foundation
import CoreData
import UIKit


public final class CoreDataManager:NSObject {
    static let shared = CoreDataManager();private override init(){}
    
    private var appDelegate:AppDelegate{
        UIApplication.shared.delegate as! AppDelegate
    }
    
    var context:NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func saveVector(x1:Double, y1:Double, x2:Double, y2:Double, color:Data,length:Double){
        guard let vectorEntityDescription = NSEntityDescription.entity(forEntityName: "Vector", in: context) else {
            print("vectorEntityDescription не сохранен")
            return}
        let vector = Vector(entity: vectorEntityDescription, insertInto: context)
        vector.x1 = x1
        vector.y1 = y1
        vector.x2 = x2
        vector.y2 = y2
        vector.color = color
        vector.length = length
        
        appDelegate.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("saveVector"), object: nil)
    }
    
    public func fetchVector() -> [Vector]{
        let fetchRequerst = NSFetchRequest<NSFetchRequestResult>(entityName: "Vector")
        do{
            return (try? context.fetch(fetchRequerst) as? [Vector]) ?? []
        }
    }
    
    public func deleteVector(_ vector:Vector){
        context.delete(vector)
        do {
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name("deleteVector"), object: nil)
        }catch {
            print("ошибка удаления")
        }
    }
    
    
//    public func updateVector(newX1:Double, newY1:Double, newX2:Double, newY2:Double,newLength:Double){
//        let fetchRequerst = NSFetchRequest<NSFetchRequestResult>(entityName: "Vector")
//        do{
//           
//        }
//        appDelegate.saveContext()
//    }
//    
//    public func deleteVector(){
//        
//    }
    
}
