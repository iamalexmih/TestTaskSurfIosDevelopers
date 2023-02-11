//
//  MainScreenViewController.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 08.02.2023.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    private let mainImage: UIImageView = {
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
    
    
    func animateMainImage(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.mainImage.frame = CGRect(x: x, y: y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
}


// MARK: - Sheet Presentation Controller Delegate
extension MainScreenViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if sheetPresentationController.selectedDetentIdentifier == .large {
            SelectedDetent.current = .large
        } else if sheetPresentationController.selectedDetentIdentifier == .mediumId {
            self.animateMainImage(x: 0, y: -200)
            SelectedDetent.current = .mediumId
        } else {
            self.animateMainImage(x: 0, y: 0)
            SelectedDetent.current = .smallId
        }
    }
}


// MARK: - setupConstraints
extension MainScreenViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
