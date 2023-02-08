//
//  DirecionCollectionViewCell.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import UIKit


final class DirecionCollectionViewCell: UICollectionViewCell {
    private var label: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(named: "colorDark")
                label.textColor = .white
            } else {
                backgroundColor = UIColor(named: "colorCell")
                label.textColor = .black
            }
        }
    }
}

extension DirecionCollectionViewCell {
    func setup(title: String) {
        label.text = title
        backgroundColor = UIColor(named: "colorCell")
        contentView.addSubview(label)
        layer.cornerRadius = 8
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
