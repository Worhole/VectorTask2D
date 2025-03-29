//
//  MainViewController.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import UIKit
import SpriteKit
import CoreData

protocol MainViewControllerDelegate:AnyObject{
    func didBurgerButtonTap()
}

class MainViewController: UIViewController {
    
    lazy var scene:MainScene={
        $0.scaleMode = .aspectFill
        $0.size = view.bounds.size
        $0.backgroundColor = .systemBackground
        
        return $0
    }(MainScene(size: view.bounds.size))
    
    var vectorCoordinate = (id:UUID(),x1:0.0,y1:0.0,x2:0.0,y2:0.0)
    
    weak var delegate:MainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "2D-полотно"
        setupBarButtons()
        setupSpriteView()
        scene.sceneDelegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBarButtons()
    }
}

private extension MainViewController {
    func setupBarButtons(){
        navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(showCreateVectorView))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(showMenu))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc
    func showMenu(){
        delegate?.didBurgerButtonTap()
    }
    
    @objc
    func showCreateVectorView(){
        let addVectorController = AddVectorViewController()
        let addVectorNav = UINavigationController(rootViewController: addVectorController)
        present(addVectorNav, animated: true)
    }
    
}


private extension MainViewController {
    private func setupSpriteView(){
        let spriteView = SKView(frame: view.bounds)
        spriteView.presentScene(scene)
        view.addSubview(spriteView)
    }
}



extension MainViewController:MainSceneDelegate{
    
    func editData(id: UUID, x1: Double, y1: Double, x2: Double, y2: Double) {
        vectorCoordinate.id = id
        vectorCoordinate.x1 = x1
        vectorCoordinate.x2 = x2
        vectorCoordinate.y1 = y1
        vectorCoordinate.y2 = y2
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
     func editVector() {
        
        navigationController?.navigationBar.topItem?.title = "Вектор выбран"
        
        let newRightButton = UIBarButtonItem(title: "Изменить",
                                             style: .done,
                                             target: self,
                                             action: #selector(updateData))
        navigationItem.rightBarButtonItem = newRightButton
        
        let newLeftButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                            style: .done, target: self,
                                            action: #selector(dismissSelection))
        navigationItem.leftBarButtonItem = newLeftButton
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    

    @objc
    func updateData() {
        CoreDataManager.shared.updateVector(id: vectorCoordinate.id, x1: vectorCoordinate.x1, y1: vectorCoordinate.y1, x2: vectorCoordinate.x2, y2: vectorCoordinate.y2)
        setupBarButtons()
        navigationItem.title = "2D-полотно"
    }

    @objc
    func dismissSelection() {
        CoreDataManager.shared.context.rollback()
        scene.selectedVector = nil
        NotificationCenter.default.post(name: NSNotification.Name("updateCanvas"), object: nil)
        setupBarButtons()
        navigationItem.title = "2D-полотно"
    }
    
}
