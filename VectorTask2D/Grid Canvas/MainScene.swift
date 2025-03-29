//
//  MainScene.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import SpriteKit
import UIKit


protocol MainSceneDelegate:AnyObject{
    func editVector()
    func editData(id:UUID,x1:Double, y1:Double, x2:Double, y2:Double)
}

class MainScene:SKScene{
    weak var sceneDelegate:MainSceneDelegate?
    
    var isTransferringVector = false
    let cameraNode = SKCameraNode()
    var grid: Grid! = Grid(blockSize: 30, rows: 10, cols: 10)

    var origPoint:CGPoint?
    var origStartPoint:CGPoint?
    var origEndPoint:CGPoint?
    var selectedVector: SKShapeNode?
    var isStretchingStart = false
    
    override func didMove(to view: SKView) {
        
        camera = cameraNode
        self.addChild(cameraNode)
        grid.anchorPoint = .zero
        self.addChild(grid)
        setupGestureRecognizers(view: view)
        setupNotifications()
        
        grawGridChildren()
    }
    
}

extension MainScene{
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(createVector), name:NSNotification.Name("createVector"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteVector), name: NSNotification.Name("deleteVector"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateChildren), name: NSNotification.Name("updateCanvas"), object: nil)
    }
    @objc
    func createVector(){
        DispatchQueue.main.async {
            self.grawGridChildren()
        }
    }
    @objc
    func deleteVector(){
        DispatchQueue.main.async {
            self.deleteGridChildren()
        }
    }
    @objc
    func updateChildren(){
        DispatchQueue.main.async {
            self.updateGridChildren()
        }
        
    }
}


extension MainScene:SideMenuContollerDelegate{
    func selectedVector(vector: Vector) {
        print("vector id: \(String(describing: vector.id))")
        if grid.children.isEmpty {
              grawGridChildren()
          }
        print(grid.children.count)
         
        for node in grid.children {
            if let vectorNode = node as? SKShapeNode, vectorNode.name == vector.id?.uuidString {
                    print(vectorNode.name as Any)
                    let origWidth = vectorNode.lineWidth
                    let increaseWidth = SKAction.run { vectorNode.lineWidth = 10}
                    let wait = SKAction.wait(forDuration: 1.0)
                    let decreaseWidth = SKAction.run { vectorNode.lineWidth = origWidth}
                    let sequence = SKAction.sequence([increaseWidth, wait, decreaseWidth])
                    vectorNode.run(sequence)
                   
                    return
                }
            }
    }
}

extension MainScene {
    
    func updateGridChildren(){
        grid.removeAllChildren()
        CoreDataManager.shared.fetchVector().forEach { fetchData in
            if grid.cols <= Int(fetchData.x1) || grid.rows <= Int(fetchData.y1) {
                grid.updateGrid(newRows: Int(fetchData.y1) + 1, newCols: Int(fetchData.x1) + 1)
            }
            if grid.cols  <= Int(fetchData.x2) || grid.rows <= Int(fetchData.y2) {
                grid.updateGrid(newRows: Int(fetchData.y2) + 1, newCols: Int(fetchData.x2) + 1)
            }
            guard let vectorId = fetchData.id?.uuidString else {return}
            let vector = DrawVector(
                from: (grid.gridPosition(x: Int(fetchData.x1), y: Int(fetchData.y1))),
                to: (grid.gridPosition(x: Int(fetchData.x2), y: Int(fetchData.y2))),
                color: UIColor.color(withData: fetchData.color))
            vector.name = vectorId
            grid.addChild(vector)
        }
    }
    
    func grawGridChildren(){
 
        let existingNodes = grid.children.compactMap { $0 as? SKShapeNode }
        
        let existingNames = Set(existingNodes.compactMap { $0.name })
        
        CoreDataManager.shared.fetchVector().forEach { fetchData in
            if grid.cols <= Int(fetchData.x1) || grid.rows <= Int(fetchData.y1) {
                grid.updateGrid(newRows: Int(fetchData.y1) + 1, newCols: Int(fetchData.x1) + 1)
            }
            if grid.cols  <= Int(fetchData.x2) || grid.rows <= Int(fetchData.y2) {
                grid.updateGrid(newRows: Int(fetchData.y2) + 1, newCols: Int(fetchData.x2) + 1)
            }
           
            guard let vectorId = fetchData.id?.uuidString else {return}
            print(fetchData.id?.uuidString ?? "nil")
                if existingNames.contains(vectorId){return}
           
                let vector = DrawVector(
                    from: (grid.gridPosition(x: Int(fetchData.x1), y: Int(fetchData.y1))),
                    to: (grid.gridPosition(x: Int(fetchData.x2), y: Int(fetchData.y2))),
                    color: UIColor.color(withData: fetchData.color))
                vector.name = vectorId
                grid.addChild(vector)
        }
        print(" после обновления grid: \(grid.children.count)")
    }
    
    func deleteGridChildren(){
        let existingNodes = grid.children.compactMap { $0 as? SKShapeNode }
        let validIDs = Set(CoreDataManager.shared.fetchVector().map { $0.id?.uuidString })
        
        for node in existingNodes {
            if let nodeName = node.name, !validIDs.contains(nodeName) {
                node.removeFromParent()
            }
        }
    }
}

private extension MainScene {
    
    func DrawVector(from startPoint: CGPoint, to endPoint: CGPoint, color:UIColor) -> SKShapeNode {
        let path = CGMutablePath()
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
      
        let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        
        let vectorHeadLength: CGFloat = 10
        
        let vectorPoint1 = CGPoint(
            x: endPoint.x - vectorHeadLength * cos(angle - .pi / 6),
            y: endPoint.y - vectorHeadLength * sin(angle - .pi / 6)
        )
        
        let vectorPoint2 = CGPoint(
            x: endPoint.x - vectorHeadLength * cos(angle + .pi / 6),
            y: endPoint.y - vectorHeadLength * sin(angle + .pi / 6)
        )
        path.move(to: endPoint)
        path.addLine(to: vectorPoint1)
        path.move(to: endPoint)
        path.addLine(to: vectorPoint2)
        
        let vectorNode = SKShapeNode(path: path)
        vectorNode.strokeColor = color
        vectorNode.lineWidth = 4
        vectorNode.lineCap = .round
        
        return vectorNode
    }
}

