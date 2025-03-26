//
//  AppDelegate.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    
    lazy var persistentContainer:NSPersistentContainer = {
        let conteiner = NSPersistentContainer(name:"VectorModel")
        conteiner.loadPersistentStores { description, error in
            if let error = error {
                print(error)
            }else {
                print("Data Base url - ",description.url?.absoluteString as Any)
            }
        }
        return conteiner
    }()
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            } catch {
                let error = error as NSError
                fatalError(error.localizedDescription)
            }
        }
    }

}

