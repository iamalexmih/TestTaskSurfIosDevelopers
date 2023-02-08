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
        //setupTapForShowSheet()
        configSheet()
        
    }
 
    private func configSheet() {
        let sheetView = BottomSheetViewController()
        let navVC = UINavigationController(rootViewController: sheetView)
        navVC.title = "123"
        navVC.isModalInPresentation = true
        if let sheet = navVC.sheetPresentationController {
            sheet.preferredCornerRadius = 32
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
            
        }
        
        navigationController?.present(navVC, animated: true)
    }
    
    
    //MARK:  Tap for show sheet
    private func setupTapForShowSheet() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showBottomSheet))
        view.addGestureRecognizer(tap)
    }

    @objc func showBottomSheet() {
        configSheet()
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
