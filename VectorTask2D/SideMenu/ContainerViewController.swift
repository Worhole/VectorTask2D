//
//  ViewController.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import UIKit


class ContainerViewController: UIViewController {
    
    enum MenuState{
        case opened,closed
    }
    
    private var menuState:MenuState = .closed
    
   
    
    let sideMenuVC = SideMenuViewController()
    let mainVC = MainViewController()
    var navVC:UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildsVC()
    }
    
    private func addChildsVC(){
        
        sideMenuVC.delegate = mainVC.scene
        
        addChild(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: self)
        
        mainVC.delegate = self
        let nav = UINavigationController(rootViewController: mainVC)
        addChild(nav)
        view.addSubview(nav.view)
        nav.didMove(toParent: self)
        self.navVC = nav
        
    }
}

extension ContainerViewController:MainViewControllerDelegate{
    func didBurgerButtonTap() {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.mainVC.view.frame.size.width * 0.33
                
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
                
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }
        }
    }
}

