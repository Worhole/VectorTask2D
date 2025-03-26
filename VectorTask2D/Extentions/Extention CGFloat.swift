//
//  Extention CGFloat.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-25.
//

import Foundation

extension CGFloat{
    static func random()->CGFloat{
        return CGFloat(arc4random()) / CGFloat(Int32.max)
    }
}
