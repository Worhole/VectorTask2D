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
    
    public func createVector(x1:Double, y1:Double, x2:Double, y2:Double, color:Data){
        guard let vectorEntityDescription = NSEntityDescription.entity(forEntityName: "Vector", in: context) else {
            print("vectorEntityDescription не сохранен")
            return}
        let vector = Vector(entity: vectorEntityDescription, insertInto: context)
        vector.x1 = x1
        vector.y1 = y1
        vector.x2 = x2
        vector.y2 = y2
        vector.color = color
     
        vector.id = UUID()
        
        appDelegate.saveContext()
        NotificationCenter.default.post(name: NSNotification.Name("createVector"), object: nil)
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
    
    public func updateVector(id:UUID,x1:Double, y1:Double, x2:Double, y2:Double){
        
        let fetchRequerst = NSFetchRequest<NSFetchRequestResult>(entityName: "Vector")
        fetchRequerst.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let vectors = try context.fetch(fetchRequerst) as? [Vector]
            guard let vector = vectors?.first else {
                print("вектор не найден")
                return
            }
            vector.x1 = x1
            vector.y1 = y1
            vector.x2 = x2
            vector.y2 = y2
            vector.id = id
            NotificationCenter.default.post(name: NSNotification.Name("updateCanvas"), object: nil)
            try context.save()
        } catch {
            print("Ошибка при обновлении вектора: \(error.localizedDescription)")
        }
     
    }
}
