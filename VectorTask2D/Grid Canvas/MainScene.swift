//
//  MainScene.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import SpriteKit
import UIKit

class MainScene:SKScene{
    
    let cameraNode = SKCameraNode()
    var rows:Int = 10
    var cols:Int = 10
    var blockSize:CGFloat = 30
    var grid:Grid?
    
    override func didMove(to view: SKView) {
        camera = cameraNode
        self.addChild(cameraNode)
        setupGestureRecognizers(view: view)
        drawGrip()
        setupNotification()
    }
}

extension MainScene{
    func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name:NSNotification.Name("saveVector"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteVector), name: NSNotification.Name("deleteVector"), object: nil)
    }
    @objc
    func reloadData(){
        DispatchQueue.main.async {
            self.drawGrip()
        }
    }
    @objc
    func deleteVector(){
        DispatchQueue.main.async {
            self.drawGrip()
        }
    }
}

extension MainScene:AddVectorDelegate {
    func addVector() {
       drawGrip()
    }
}

extension MainScene:SideMenuContollerDelegate{
    func didSelect(menuItem: Vector) {
        print(menuItem.length)
    }
    
    func didRemove() {
        print("удалилос")
    }
}

extension MainScene {

    func drawGrip(){
        guard let grid = Grid(blockSize: blockSize, rows: rows, cols: cols) else {return}
        grid.anchorPoint = .zero
        self.grid = grid
        self.addChild(grid)
    
        CoreDataManager.shared.fetchVector().forEach { fetchData in
            if cols <= Int(fetchData.x1) || rows <= Int(fetchData.y1) {
                grid.updateGrid(newRows: Int(fetchData.y1) + 1, newCols: Int(fetchData.x1) + 1)
            }
            if cols <= Int(fetchData.x2) || rows <= Int(fetchData.y2) {
                grid.updateGrid(newRows: Int(fetchData.y2) + 1, newCols: Int(fetchData.x2) + 1)
            }
            let vector = DrawVector(
                from: grid.gridPosition(x: Int(fetchData.x1), y: Int(fetchData.y1)),
                to: grid.gridPosition(x: Int(fetchData.x2), y: Int(fetchData.y2)),
                color: UIColor.color(withData: fetchData.color))
            grid.addChild(vector)
        }
        
        print("добавил")
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

private extension MainScene {
    private func setupGestureRecognizers(view: SKView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view)
        
        if gesture.state == .changed {
            let newX = cameraNode.position.x - translation.x
            let newY = cameraNode.position.y + translation.y
            cameraNode.position = CGPoint(x: newX, y: newY)
            gesture.setTranslation(.zero, in: gesture.view)
        }
    }
}
