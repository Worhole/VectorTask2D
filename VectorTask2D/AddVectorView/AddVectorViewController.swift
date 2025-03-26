//
//  AddVectorViewController.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import UIKit

protocol AddVectorDelegate:AnyObject {
    func addVector()
}

class AddVectorViewController: UIViewController {
    
    weak var delegate:AddVectorDelegate?
    var isEnabledAdd = false

    lazy var x1Label:UILabel = {
        $0.text = "x₁"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var y1Label:UILabel = {
        $0.text = "y₁"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var x2Label:UILabel = {
        $0.text = "x₂"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var y2Label:UILabel = {
        $0.text = "y₂"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var x1TextField:UITextField = {
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always
 
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .line
        $0.addTarget(self, action: #selector(updateAddButtonState), for: .editingChanged)
        return $0
    }(UITextField())
    
    lazy var y1TextField:UITextField = {
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always

        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .line
        $0.addTarget(self, action: #selector(updateAddButtonState), for: .editingChanged)
        return $0
    }(UITextField())
    
    lazy var x2TextField:UITextField = {
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always
       
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .line
        $0.addTarget(self, action: #selector(updateAddButtonState), for: .editingChanged)
        return $0
    }(UITextField())
    
    lazy var y2TextField:UITextField = {
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: $0.frame.height))
        $0.leftViewMode = .always

        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .line
        $0.addTarget(self, action: #selector(updateAddButtonState), for: .editingChanged)
        return $0
    }(UITextField())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupAddVectorLayout()
        setupBarItem()
    }
}

private extension AddVectorViewController {
    func setupAddVectorLayout(){
        
        view.addSubview(x1TextField)
        view.addSubview(y1TextField)
        
        view.addSubview(x2TextField)
        view.addSubview(y2TextField)
        
        view.addSubview(x1Label)
        view.addSubview(y1Label)
        view.addSubview(x2Label)
        view.addSubview(y2Label)
        
        NSLayoutConstraint.activate([
            x1TextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            x1TextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 60),
            x1TextField.widthAnchor.constraint(equalToConstant: 70),
            x1TextField.heightAnchor.constraint(equalToConstant: 40),
            
            y1TextField.topAnchor.constraint(equalTo: x1TextField.bottomAnchor,constant: 30),
            y1TextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 60),
            y1TextField.widthAnchor.constraint(equalToConstant: 70),
            y1TextField.heightAnchor.constraint(equalToConstant: 40),
            
            x2TextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            x2TextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -60),
            x2TextField.widthAnchor.constraint(equalToConstant: 70),
            x2TextField.heightAnchor.constraint(equalToConstant: 40),
            
            y2TextField.topAnchor.constraint(equalTo: x2TextField.bottomAnchor,constant: 30),
            y2TextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -60),
            y2TextField.widthAnchor.constraint(equalToConstant: 70),
            y2TextField.heightAnchor.constraint(equalToConstant: 40),
            
            x1Label.bottomAnchor.constraint(equalTo: x1TextField.topAnchor, constant: -2),
            x1Label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 60),
            x1Label.widthAnchor.constraint(equalToConstant: 15),
            x1Label.heightAnchor.constraint(equalToConstant: 15),
            
            y1Label.bottomAnchor.constraint(equalTo: y1TextField.topAnchor, constant: -2),
            y1Label.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 60),
            y1Label.widthAnchor.constraint(equalToConstant: 15),
            y1Label.heightAnchor.constraint(equalToConstant: 20),
            
            x2Label.bottomAnchor.constraint(equalTo: x2TextField.topAnchor, constant: -2),
            x2Label.leadingAnchor.constraint(equalTo: x2TextField.leadingAnchor),
            x2Label.widthAnchor.constraint(equalToConstant: 15),
            x2Label.heightAnchor.constraint(equalToConstant: 15),
            
            y2Label.bottomAnchor.constraint(equalTo: y2TextField.topAnchor, constant: -2),
            y2Label.leadingAnchor.constraint(equalTo: y2TextField.leadingAnchor),
            y2Label.widthAnchor.constraint(equalToConstant: 15),
            y2Label.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}

private extension AddVectorViewController {
    func setupBarItem(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(tapDismiss))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(tapAdd))
        navigationItem.rightBarButtonItem?.tintColor =  .systemPurple
        navigationItem.title = "Add Vector"
        navigationItem.rightBarButtonItem?.isEnabled = isEnabledAdd
    }
    
    @objc
    func updateAddButtonState() {
        let coordinateFields = [x1TextField, x2TextField, y1TextField, y2TextField]
        isEnabledAdd = coordinateFields.allSatisfy { ($0.text?.isEmpty == false) }
        navigationItem.rightBarButtonItem?.isEnabled = isEnabledAdd
    }
    
    @objc
    func tapDismiss(){
        dismiss(animated: true)
    }
    
    @objc
    func tapAdd(){
        if let delegate = delegate{
            guard let strX1 = x1TextField.text,let strX2 = x2TextField.text ,let strY1 = y1TextField.text ,let strY2 = y2TextField.text  else {return}
            guard let x1 = Double(strX1),let x2 = Double(strX2),let y1 = Double(strY1) ,let y2 = Double(strY2) else {return}
            
            let vectorColor = UIColor.randomColor().encode()
            CoreDataManager.shared.saveVector(x1: x1, y1: y1, x2: x2, y2: y2, color: vectorColor, length: vectorLength(_x1: x1, y1: y1, _x2: x2, y2: y2))
            
            delegate.addVector()
        }
        dismiss(animated: true)
        print("Add")
    }
    func vectorLength(_x1: Double, y1: Double, _x2: Double, y2: Double)->Double{
        let dx = Double(_x2 - _x1)
        let dy = Double(y2 - y1)
        return sqrt(dx * dx + dy * dy)
    }
}
