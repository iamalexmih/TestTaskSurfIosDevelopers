//
//  ViewController.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import UIKit

protocol BottomSheetViewControllerProtocol: AnyObject {
    func setLabelTry(_ text: String)
    func setLabelThinksComputer(_ text: String)
    func setLabelHumanAnswer(_ text: String)
}


class BottomSheetViewController: UIViewController {

    var presenter: PresenterProtocol!
    
    var sections: [SectionModel] = []
    var createLayout: CreateLayout = CreateLayout()
    var dataSourceDiffable: UICollectionViewDiffableDataSource<SectionModel, DirectionItems>?
    private var collectionView: UICollectionView!

    
    private let labelTitleA: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Стажировка в Surf"
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        label.textColor = UIColor(named: "colorDark")
        return label
    }()
    
    
    private let labelDoYouWant: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Хочешь к нам?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let buttonSendRequest: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить заявку", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(named: "colorDark")
        button.tintColor = .white
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(alertWindow), for: .touchUpInside)
        return button
    }()
    
    private let bottomStackViewForRequest: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        sections = MockData.shared.getSections()
        
        setupCollectionView()
        createDataSource()
        reloadDataDiffableSnapshot()
        
        addSubviewOnView()
        setupConstraints()
    }
}


// MARK: Constraints and addSubview

private extension BottomSheetViewController {
    
    private func addSubviewOnView() {
        view.addSubview(bottomStackViewForRequest)
        
        bottomStackViewForRequest.addArrangedSubview(labelDoYouWant)
        bottomStackViewForRequest.addArrangedSubview(buttonSendRequest)
    
        view.addSubview(collectionView)
        view.addSubview(labelTitleA)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelTitleA.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            labelTitleA.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            labelTitleA.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            buttonSendRequest.widthAnchor.constraint(equalToConstant: 220),
            
            bottomStackViewForRequest.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomStackViewForRequest.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomStackViewForRequest.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            bottomStackViewForRequest.heightAnchor.constraint(equalToConstant: 70),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: labelTitleA.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: bottomStackViewForRequest.topAnchor, constant: -10),
        ])
    }
}



// MARK: config collection view
private extension BottomSheetViewController {
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: createLayout.createCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: UICollectionViewCell.cellId)
        collectionView.register(DirecionCollectionViewCell.self,
                                forCellWithReuseIdentifier: DirecionCollectionViewCell.cellId)
        collectionView.register(SectionHeaderForOneRow.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderForOneRow.reuseId)
        
    }

    
    // MARK: - Manage the data source
    
    func createDataSource() {
        dataSourceDiffable = UICollectionViewDiffableDataSource<SectionModel, DirectionItems>(
            collectionView: collectionView, cellProvider: { [weak self]
                collectionView, indexPath, item in
               
                guard let self = self else { return nil }
                switch self.sections[indexPath.section].type {
                case "TwoRows":
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DirecionCollectionViewCell.cellId,
                                                                  for: indexPath) as! DirecionCollectionViewCell
                    cell.setup(title: item.direction)
                    cell.sizeToFit()
                    return cell
                default:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DirecionCollectionViewCell.cellId,
                                                                  for: indexPath) as! DirecionCollectionViewCell
                    cell.setup(title: item.direction)
                    cell.sizeToFit()
                    
                    return cell
                }
        })
        
        dataSourceDiffable?.supplementaryViewProvider = { [weak self]
            (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderForOneRow.reuseId,
                for: indexPath) as? SectionHeaderForOneRow else { return nil }
            
            sectionHeader.configHeader(textHeader: self?.sections[indexPath.section].title)
            return sectionHeader
        }
    }
    
    func reloadDataDiffableSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, DirectionItems>()
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSourceDiffable?.apply(snapshot)
    }
}

// MARK: config collection view
private extension BottomSheetViewController {
    @objc func alertWindow() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Ваша заявка успешно отправлена!", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "Закрыть", style: .default)
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
}
