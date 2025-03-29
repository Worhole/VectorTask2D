//
//  Gestures.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-28.
//

import UIKit
import SpriteKit
import CoreData

extension MainScene {
    
    func setupGestureRecognizers(view: SKView) {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.delaysTouchesBegan = true
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(vectorLongPress))
        view.addGestureRecognizer(longPressGesture)
        
        let stretchingGesture = UIPanGestureRecognizer(target: self, action: #selector(stretchingGepsture))
        stretchingGesture.minimumNumberOfTouches = 1
        stretchingGesture.delaysTouchesBegan = true
        stretchingGesture.delegate = self
        view.addGestureRecognizer(stretchingGesture)
        
        let transferGesture = UIPanGestureRecognizer(target: self, action: #selector(transferVector))
        transferGesture.minimumNumberOfTouches = 1
        transferGesture.delaysTouchesBegan = true
        transferGesture.delegate = self
        view.addGestureRecognizer(transferGesture)
        
    }
    
    @objc
     func panGesture(gesture: UIPanGestureRecognizer) {
     
        guard selectedVector == nil else {return}
        
        let translation = gesture.translation(in: gesture.view)
        if gesture.state == .changed {
            let newX = cameraNode.position.x - translation.x
            let newY = cameraNode.position.y + translation.y
            cameraNode.position = CGPoint(x: newX, y: newY)
            gesture.setTranslation(.zero, in: gesture.view)
        }
    }
    
    
    @objc func vectorLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        let convertedLocation = convertPoint(fromView: location)
        let newLocation = convert(convertedLocation, to: grid)
        
        let node = atPoint(newLocation)
        
        if gestureRecognizer.state == .ended {
            selectedVector = nil
        }
        
        
        if let vectorNode = node as? SKShapeNode {
            sceneDelegate?.editVector()
            selectedVector = vectorNode
            
            
            guard let path = vectorNode.path else {return}
            
            var points = [CGPoint](repeating: .zero, count: 2)
            
            var index = 0
            path.applyWithBlock { element in
                if index < 2 {
                    points[index] = element.pointee.points.pointee
                    index += 1
                }
            }
            
            let startPoint = points[0]
            let endPoint = points[1]
            
            let centerPoint = CGPoint(
                x: (startPoint.x + endPoint.x) / 2,
                y: (startPoint.y + endPoint.y) / 2
            )
            
            let distanceToStart = hypot(startPoint.x - newLocation.x, startPoint.y - newLocation.y)
            let distanceToEnd = hypot(endPoint.x - newLocation.x, endPoint.y - newLocation.y)
            let distanceToCenter = hypot(centerPoint.x - newLocation.x, centerPoint.y - newLocation.y)
    
            let centerRadius: CGFloat = 50
            let endsRadius: CGFloat = 30
            origPoint = isStretchingStart ? startPoint : endPoint
            if distanceToStart < endsRadius || distanceToEnd < endsRadius {
                isStretchingStart = distanceToStart < distanceToEnd
                isTransferringVector = false
            }
            if distanceToCenter < centerRadius {
                origPoint = nil
                isStretchingStart = false
                isTransferringVector = true
            }
            
            let convertNode = convert(startPoint, to: grid)
            let convertEnd = convert(endPoint, to: grid)
            
            let gridX = Int(round(convertNode.x / grid.blockSize))
            let gridY = Int(round(convertNode.y / grid.blockSize))
            
            let delta = grid.gridPosition(x: gridX, y: gridY)
            
            let vectorstartX = delta.x / grid.blockSize
            let vectorstartY = delta.y / grid.blockSize
            
            let gridendX = Int(round(convertEnd.x / grid.blockSize))
            let gridendY = Int(round(convertEnd.y / grid.blockSize))
            
            let deltaend = grid.gridPosition(x: gridendX, y: gridendY)
            
            let vectorEndX = deltaend.x / grid.blockSize
            let vectorEndY = deltaend.y / grid.blockSize
            
            origStartPoint = CGPoint(x: vectorstartX, y: vectorstartY)
            origEndPoint = CGPoint(x: vectorEndX, y: vectorEndY)
        }
    }
    
    @objc func stretchingGepsture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if isTransferringVector { return }
        guard let vectorNode = selectedVector, let path = vectorNode.path, origPoint != nil else { return }
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let newLocation = CGPoint(x: origPoint!.x + translation.x, y: origPoint!.y - translation.y)
        var points = [CGPoint](repeating: .zero, count: 2)
        
        var index = 0
        path.applyWithBlock { element in
            if index < 2 {
                points[index] = element.pointee.points.pointee
                index += 1
            }
        }
       
        
        if gestureRecognizer.state == .ended {
            selectedVector = nil
        }
        
        if isStretchingStart {
            points[0] = newLocation

        } else {
            points[1] = newLocation
    
        }
        
        let mutablePath = CGMutablePath()
        mutablePath.move(to: points[0])
        mutablePath.addLine(to: points[1])
        
        let angle = atan2(points[1].y - points[0].y, points[1].x - points[0].x)
        let vectorHeadLength: CGFloat = 10
        
        let vectorPoint1 = CGPoint(
            x: points[1].x - vectorHeadLength * cos(angle - .pi / 6),
            y: points[1].y - vectorHeadLength * sin(angle - .pi / 6)
        )
        
        let vectorPoint2 = CGPoint(
            x: points[1].x - vectorHeadLength * cos(angle + .pi / 6),
            y: points[1].y - vectorHeadLength * sin(angle + .pi / 6)
        )
        
        mutablePath.move(to: points[1])
        mutablePath.addLine(to: vectorPoint1)
        mutablePath.move(to: points[1])
        mutablePath.addLine(to: vectorPoint2)
        
        if gestureRecognizer.state == .ended{
            let convertStartNode = convert(points[0], to: grid)
            let convertEndNode = convert(points[1], to: grid)
            
            let gridStartX = Int(round(convertStartNode.x / grid.blockSize))
            let gridStartY = Int(round(convertStartNode.y / grid.blockSize))
            
            let gridEndX = Int(round(convertEndNode.x / grid.blockSize))
            let gridEndY = Int(round(convertEndNode.y / grid.blockSize))
            
            let pointStart = CGPoint(x: gridStartX, y: gridStartY)
            let pointEnd = CGPoint(x: gridEndX, y: gridEndY)
            
            if  let uuid = UUID(uuidString: vectorNode.name!){
                sceneDelegate?.editData(id: uuid, x1: pointStart.x, y1: pointStart.y, x2: pointEnd.x, y2: pointEnd.y)
            }
            
            
        }
        vectorNode.path = mutablePath
        gestureRecognizer.setTranslation(.zero, in: gestureRecognizer.view)
    }
    
    
    @objc
    func transferVector(_ gestureRecognizer: UIPanGestureRecognizer){
        
        if !isTransferringVector { return }
        
        guard let vectorNode = selectedVector, origStartPoint != nil, origEndPoint != nil else {return}
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        
        if gestureRecognizer.state == .changed {
            let newX = vectorNode.position.x + translation.x
            let newY = vectorNode.position.y - translation.y
            vectorNode.position = CGPoint(x: newX, y: newY)
            gestureRecognizer.setTranslation(.zero, in: gestureRecognizer.view)
        }
        if gestureRecognizer.state == .ended {
            let convertNode = convert(vectorNode.position, to: grid)
            
            let vectorOffsetX = Double(round(convertNode.x / grid.blockSize))
            let vectorOffsetY = Double(round(convertNode.y / grid.blockSize))
          
            vectorNode.position = grid.gridPosition(x: Int(vectorOffsetX), y: Int(vectorOffsetY))
            
            if  let uuid = UUID(uuidString: vectorNode.name!){
                
                let x1 = Double(vectorOffsetX + origStartPoint!.x)
                
                let y1 = Double(vectorOffsetY + origStartPoint!.y)
                
                let x2 = Double(vectorOffsetX + origEndPoint!.x)
                
                let y2 = Double(vectorOffsetY + origEndPoint!.y)
                
                sceneDelegate?.editData(id: uuid, x1: x1, y1: y1, x2: x2, y2: y2)
            }
            
            isTransferringVector = false
            selectedVector = nil
        }
    }
    
}
extension MainScene: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


