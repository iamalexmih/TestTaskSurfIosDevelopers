//
//  LayoutOneRow.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import UIKit


final class CreateLayout {
    func createCompositionalLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            let section = MockData.shared.getSections()[sectionIndex]
            
            switch section.type {
            case "OneRow":
                return self.createOneRowSection()
            default:
                return self.createTwoRowSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 24
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider,
                                                         configuration: config)
        return layout
    }
    
    
    private func createOneRowSection() -> NSCollectionLayoutSection {
        
        let estimatedHeight: CGFloat = 24
        let estimatedWidth: CGFloat = 55
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: 20,
                                                        bottom: 0,
                                                        trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createTwoRowSection() -> NSCollectionLayoutSection {
        
        let estimatedHeight: CGFloat = 24
        let estimatedWidth: CGFloat = 55
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .estimated(1),
                                                                         heightDimension: .estimated(100)),
                                                       subitems: [item])
        group.interItemSpacing = .fixed(12)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: 20,
                                                        bottom: 0,
                                                        trailing: 0)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 12
        
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createTwoRowSectionList() -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 24
        let estimatedWidth: CGFloat = 55
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .estimated(1),
                                                                         heightDimension: .absolute(100)),
                                                       subitems: [item])
        group.interItemSpacing = .fixed(12)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: 20,
                                                        bottom: 0,
                                                        trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        section.interGroupSpacing = 12
        
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
                                                                     leading: 0,
                                                                     bottom: 0,
                                                                     trailing: 12)
        return layoutSectionHeader
    }
}
