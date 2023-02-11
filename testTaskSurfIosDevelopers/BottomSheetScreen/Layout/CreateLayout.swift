//
//  LayoutOneRow.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import UIKit


class CreateLayout {
    func createCompositionalLayout(isLarge: Bool, detent: UISheetPresentationController.Detent.Identifier) -> UICollectionViewLayout {
        let sectionProvider = { [weak self]
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            let section = MockData.shared.getSections()[sectionIndex]
            
            if detent == .smallId {
                switch section.type {
                default:
                    return self.createOneRowSection()
                }
            } else {
                switch section.type {
                case "OneRow":
                    return self.createOneRowSection()
                default:
                    return self.createSectionAdditional(isList: isLarge)
                }
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
    
    
    private func createSectionAdditional(isList: Bool) -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 24
        let estimatedWidth: CGFloat = 55
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        var group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .estimated(1),
                                                                         heightDimension: .absolute(100)),
                                                       subitems: [item])
       
        if isList {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                         heightDimension: .estimated(100)),
                                                       subitems: [item])
        }
        
        group.interItemSpacing = .fixed(12)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 12,
                                                        leading: 20,
                                                        bottom: 0,
                                                        trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        
        if isList {
            section.orthogonalScrollingBehavior = .none
        }
        
        section.interGroupSpacing = 12
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }
        
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
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
    
    
    
    
    
    class WaterfallLayout {
        static let homeBottomMargin: CGFloat = 80

        static func createSection(environment: NSCollectionLayoutEnvironment, sizeCollection: [CGSize]) -> NSCollectionLayoutSection {
            var items: [NSCollectionLayoutGroupCustomItem] = []
            var layouts: [Int: CGFloat] = [:]
            let space: CGFloat = 4
            let numberOfColumn: CGFloat = 2

            (0..<Int(numberOfColumn)).forEach { layouts[$0] = 0 }

            sizeCollection.forEach { size in
                let aspect = CGFloat(size.height) / CGFloat(size.width)

                let width = (environment.container.effectiveContentSize.width - (numberOfColumn + 1) * space) / numberOfColumn
                let height = width * aspect

                // 各列から最小の高さを計算
                let minHeight = layouts.min(by: { a, b in a.value < b.value })?.value ?? 0
                // 最小の高さを持つ列が複数あった場合、左からセルを整列させる
                let nextColumn = layouts
                    .filter { layout in layout.value == minHeight }
                    .map { $0.key }
                    .min() ?? 0

                let y = layouts[nextColumn] ?? 0.0 + space
                let x = width * CGFloat(nextColumn) + space * (CGFloat(nextColumn) + 1)

                let frame = CGRect(x: x, y: y + space, width: width, height: height)
                let item = NSCollectionLayoutGroupCustomItem(frame: frame)
                items.append(item)

                layouts[nextColumn] = frame.maxY
            }
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute((layouts.max(by: { a, b in a.value < b.value })?.value ?? 0) + homeBottomMargin)
            )
            let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { _ -> [NSCollectionLayoutGroupCustomItem] in
                return items
            }
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0)

            return section
        }
    }
}
