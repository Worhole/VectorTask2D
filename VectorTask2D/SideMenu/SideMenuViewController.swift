//
//  SideMenuViewController.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import UIKit

protocol SideMenuContollerDelegate:AnyObject{
    func didSelect(menuItem: Vector)
    func didRemove()
}

class SideMenuViewController: UIViewController {
    
    weak var delegate:SideMenuContollerDelegate?
    
    private(set) var model:[Vector] = [] {
        didSet{
            DispatchQueue.main.async {
                self.menuTable.reloadData()
            }
        }
    }
    
    lazy var menuTable:UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .systemGray6
        $0.showsVerticalScrollIndicator = false
        $0.register(SideMenuCell.self, forCellReuseIdentifier: SideMenuCell.reuseId)
        return $0
    }(UITableView(frame: CGRect(x: Int(view.frame.origin.x), y: Int(view.frame.origin.y), width: Int(UIScreen.main.bounds.width/3), height:  Int(UIScreen.main.bounds.height))))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotification()
        view.backgroundColor = .systemGray6
        view.addSubview(menuTable)
        fetchData()
    }
}

extension SideMenuViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.reuseId, for: indexPath) as! SideMenuCell
        cell.backgroundColor = .systemGray6
        cell.contentView.backgroundColor = .systemGray6
        let info = model[indexPath.row]
        cell.cellConfigure(info)
        return cell
    }
}

extension SideMenuViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(menuItem: model[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeAction = UIContextualAction(style: .destructive, title: "удалить") { action, view, completion in
            CoreDataManager.shared.deleteVector(self.model[indexPath.row])
            self.model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delegate?.didRemove()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
}

extension SideMenuViewController {
    func fetchData(){
        model = CoreDataManager.shared.fetchVector()
    }
}

extension SideMenuViewController {
    func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name:NSNotification.Name("saveVector"), object: nil)
    }
    @objc
    func reloadData(){
        DispatchQueue.main.async {
            self.model = CoreDataManager.shared.fetchVector()
            self.menuTable.reloadData()
        }
    }
}

