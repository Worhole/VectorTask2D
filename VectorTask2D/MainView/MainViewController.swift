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
     func editVector() {
        
        navigationController?.navigationBar.topItem?.title = "Вектор выбран"
        
        let newRightButton = UIBarButtonItem(title: "Изменить",
                                             style: .done,
                                             target: self,
                                             action: #selector(editData))
        navigationItem.rightBarButtonItem = newRightButton
        
        let newLeftButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                            style: .done, target: self,
                                            action: #selector(dismissSelection))
        navigationItem.leftBarButtonItem = newLeftButton
    }
    

    @objc
    func editData() {
        setupBarButtons()
        navigationItem.title = "2D-полотно"
    }

    @objc
    func dismissSelection() {
        NotificationCenter.default.post(name: NSNotification.Name("updateCanvas"), object: nil)
        scene.selectedVector = nil
        setupBarButtons()
        navigationItem.title = "2D-полотно"
    }
    
}
