//
//  ViewController.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import UIKit

protocol ViewControllerProtocol: AnyObject {
    func setLabelTry(_ text: String)
    func setLabelThinksComputer(_ text: String)
    func setLabelHumanAnswer(_ text: String)
}


class ViewController: UIViewController {

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


private extension ViewController {
    
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
//                case "activeChats":
//                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
//                                                                    ActiveChatCell.reuseId,
//                                                                  for: indexPath) as? ActiveChatCell
//                    cell?.configure(with: chat)
//                    return cell
                    // дефолтный case будет отвечать за секцию "waitingChats"
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
            
            
            
            // получаем текст для ячейки Header
//            guard let firstChat = self?.dataSourceDiffable?.itemIdentifier(for: indexPath)
//            else { return nil }

//            guard let section = self?.dataSourceDiffable?.snapshot().sectionIdentifier(containingItem: firstChat)
//            else { return nil }

//            if section.title.isEmpty { return nil }
            
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
    
    
    // MARK: - Setup Compositional Layout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            
            switch section.type {
//            case "activeChats":
//                return self.createActiveChatSection()
            default:
                return self.createOneRowSection()
            }
        }
        
        // Расстояние между секциями
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 40
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider,
                                                         configuration: config)
        return layout
    }
    
    
    private func createOneRowSection() -> NSCollectionLayoutSection {
        
        let estimatedHeight: CGFloat = 1
        let estimatedWidth: CGFloat = 1
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 20,
                                                        bottom: 0,
                                                        trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .estimated(1))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        layoutSectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                                     leading: 24,
                                                                     bottom: 0,
                                                                     trailing: 12)
        return layoutSectionHeader
    }
}
