//
//  UICollectionView + cellId.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import UIKit


extension UICollectionViewCell {
    static var cellId: String {
        String(describing: self)
    }
}
