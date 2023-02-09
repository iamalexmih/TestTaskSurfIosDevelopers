//
//  MainScreenViewController.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 08.02.2023.
//

import UIKit

class MainScreenViewController: UIViewController {

    let mainImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "mainImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainImage)
        setupConstraints()
        configSheet()
        
    }
 
    private func configSheet() {
        let sheetView = BottomSheetViewController()
        let navVC = UINavigationController(rootViewController: sheetView)
        navVC.isModalInPresentation = true
        
        let smallId = UISheetPresentationController.Detent.Identifier("small")
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: smallId) { context in
           return 270
        }
        
        let mediumId = UISheetPresentationController.Detent.Identifier("medium")
        let mediumDetent = UISheetPresentationController.Detent.custom(identifier: mediumId) { context in
           return 450
        }
        
        
        
        if let sheet = navVC.sheetPresentationController {
            sheet.preferredCornerRadius = 32
            sheet.detents = [smallDetent , mediumDetent, .large()]
            sheet.largestUndimmedDetentIdentifier = .large
        }
        
        navigationController?.present(navVC, animated: true)
    }

}


extension MainScreenViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: view.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
