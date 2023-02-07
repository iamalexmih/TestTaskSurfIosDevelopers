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
    //private var formComposLayout = FormCompositionalLayout()
    private var layout = CreateLayout()
    private lazy var diffableDataSourse = makeDiffableDataSource()

    
    private var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setupCollectioView()
        setup()
        sectionHeader()
        updateDataSourse()
    }
}


private extension ViewController {
    
    func setupCollectioView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout.createCompositionalLayout())
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
        view.backgroundColor = .white
        
        collectionView.dataSource = diffableDataSourse
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func makeDiffableDataSource() -> UICollectionViewDiffableDataSource<SectionModel, DirectionItems> {
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
             
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DirecionCollectionViewCell.cellId,
                                                              for: indexPath) as! DirecionCollectionViewCell
                cell.setup(title: item.direction)
                cell.sizeToFit()
                return cell
            }
        }
    }
    
    func sectionHeader() {
        diffableDataSourse.supplementaryViewProvider = { [weak self]
            collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderForOneRow.reuseId,
                for: indexPath) as? SectionHeaderForOneRow else { return nil }
            
            // получаем текст для ячейки Header
            guard let firstChat = self.diffableDataSourse.itemIdentifier(for: indexPath)
            else { return nil }
            print(firstChat)
            guard let section = self.diffableDataSourse.snapshot().sectionIdentifier(containingItem: firstChat)
            else { return nil }
            
            if section.title.isEmpty { return nil }
            sectionHeader.configHeader(textHeader: section.title)
            return sectionHeader
        }
    }
    
    
    func updateDataSourse(animated: Bool = false) {
        Dispatch.DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            var snapshot = NSDiffableDataSourceSnapshot<SectionModel, DirectionItems>()

            let formSections = MockData.shared.getSections()
            snapshot.appendSections(formSections)
            
            
            for section in formSections {
                snapshot.appendItems(section.items, toSection: section)
            }

            self.diffableDataSourse.apply(snapshot, animatingDifferences: animated)
        }
    }
    
    
 
}
