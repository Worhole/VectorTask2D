//
//  Extention UIColor.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import UIKit

extension UIColor {
    static func randomColor()->UIColor{
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
    
   class func color(withData data:Data) -> UIColor {
        return try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)!
    }

    func encode() -> Data {
         return NSKeyedArchiver.archivedData(withRootObject: self)
    }
}

