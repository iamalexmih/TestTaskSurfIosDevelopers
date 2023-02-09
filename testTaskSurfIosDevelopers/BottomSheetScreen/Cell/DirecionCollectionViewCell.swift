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
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    var section: Int = 1
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if label.textColor == .white {
                    backgroundColor = UIColor(named: "colorCell")
                    label.textColor = .black
                } else {
                    backgroundColor = UIColor(named: "colorDark")
                    label.textColor = .white
                }
            } else {
                backgroundColor = UIColor(named: "colorCell")
                label.textColor = .black
            }
        }
    }
}

extension DirecionCollectionViewCell {
    func setup(title: String, section: Int) {
        label.text = title
        label.textColor = .black
        backgroundColor = UIColor(named: "colorCell")
        contentView.addSubview(label)
        layer.cornerRadius = 8
        clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        self.section = section
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
