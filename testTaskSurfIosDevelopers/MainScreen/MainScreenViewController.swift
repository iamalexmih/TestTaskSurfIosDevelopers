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
        
        let smallDetent = UISheetPresentationController.Detent.custom(identifier: .smallId) { context in
           return 270
        }
        
        let mediumDetent = UISheetPresentationController.Detent.custom(identifier: .mediumId) { context in
           return 450
        }
        
        if let sheet = navVC.sheetPresentationController {
            sheet.preferredCornerRadius = 32
            sheet.detents = [smallDetent , mediumDetent, .large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.delegate = self
        }
        
        navigationController?.present(navVC, animated: true)
    }
}


// MARK: - Sheet Presentation Controller Delegate
extension MainScreenViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if sheetPresentationController.selectedDetentIdentifier == .large {
            SelectedDetent.current = .large
        } else if sheetPresentationController.selectedDetentIdentifier == .mediumId {
            SelectedDetent.current = .mediumId
        } else {
            SelectedDetent.current = .smallId
        }
    }
}


// MARK: - setupConstraints
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
