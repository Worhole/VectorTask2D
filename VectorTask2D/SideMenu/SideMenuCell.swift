//
//  SideMenuCell.swift
//  VectorTask2D
//
//  Created by 71m3 on 2025-03-21.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    static let reuseId = "SideMenuCell"
    
    lazy var pointA: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.lineBreakMode = .byCharWrapping
        return $0
    }(UILabel())
    
    lazy var pointB: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.lineBreakMode = .byCharWrapping
        return $0
    }(UILabel())
    
    lazy var length: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    lazy var stackView:UIStackView = {
        $0.spacing = 4
        $0.axis = .vertical
        $0.alignment = .leading
        return $0
    }(UIStackView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellLayout(){
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(pointA)
        stackView.addArrangedSubview(pointB)
        stackView.addArrangedSubview(length)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func cellConfigure(_ vectorInfo:Vector){
        pointA.text = "A(\(vectorInfo.x1);\(vectorInfo.y1))"
        pointB.text = "B(\(vectorInfo.x2);\(vectorInfo.y2))"
        length.text = "Длина: \(vectorInfo.length)"
    }
}
