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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = MockData.shared.getSections()
        
        setupCollectionView()
        setup()
        createDataSource()
        reloadDataDiffableSnapshot()
    }
}


private extension BottomSheetViewController {
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: createLayout.createCompositionalLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: UICollectionViewCell.cellId)
        collectionView.register(DirecionCollectionViewCell.self,
                                forCellWithReuseIdentifier: DirecionCollectionViewCell.cellId)
        collectionView.register(SectionHeaderForOneRow.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderForOneRow.reuseId)
    }
    
    func setup() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
