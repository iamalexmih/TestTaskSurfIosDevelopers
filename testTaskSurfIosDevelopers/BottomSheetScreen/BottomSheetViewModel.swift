//
//  Presenter.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import Foundation


protocol BottomSheetViewModelProtocol: AnyObject {
    var countItemsForSircle: Int { get }
    var indexForReverseScroll: IndexPath { get }
    var countSection: Int { get }
    
    func itemCount(_ section: Int) -> Int
    func typeSection(_ section: Int) -> String
    func getItemTitle(_ section: Int, _ row: Int) -> String
    func getHeaderTitle(_ section: Int) -> String
}


class BottomSheetViewModel: BottomSheetViewModelProtocol {
    private let mockData: [SectionModel]

    var countItemsForSircle: Int = 10_000
    var indexForReverseScroll: IndexPath {
        IndexPath(item: countItemsForSircle / 2, section: 0)
    }
    
    var countSection: Int {
        mockData.count
    }
    
    func itemCount(_ section: Int) -> Int {
        mockData[section].items.count
    }
    
    func typeSection(_ section: Int) -> String {
        mockData[section].type
    }
    
    func getItemTitle(_ section: Int, _ row: Int) -> String {
        mockData[section].items[row].direction
    }
    
    func getHeaderTitle(_ section: Int) -> String {
        mockData[section].title
    }
    
    required init() {
        self.mockData = MockData.shared.getSections()
    }
    
    
}
