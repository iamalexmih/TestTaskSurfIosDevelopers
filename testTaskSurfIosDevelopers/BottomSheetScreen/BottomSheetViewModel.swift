//
//  Presenter.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import Foundation


protocol BottomSheetViewModelProtocol: AnyObject {
    var countItemsForSircle: Int { get set }
    var indexForReverseScroll: IndexPath { get }
    var countSection: Int { get }
    
    func itemCount(_ section: Int) -> Int
    func typeSection(_ section: Int) -> String
    func getItemTitle(_ section: Int, _ row: Int, circleScroll: Bool) -> String
    func getHeaderTitle(_ section: Int) -> String
    func moveItemToBeginning(_ indexPath: IndexPath)
    func calculateCounterForCircleScroll(_ indexPath: IndexPath) -> Bool
}


class BottomSheetViewModel: BottomSheetViewModelProtocol {
    private var mockData: [SectionModel]
    
    var countItemsForSircle: Int = 400
    var indexForReverseScroll: IndexPath {
        IndexPath(item: countItemsForSircle / 2, section: 0)
    }
    
    
    var countSection: Int {
        mockData.count
    }
    
    
    required init() {
        self.mockData = MockData.shared.getSections()
    }
    
    
    func itemCount(_ section: Int) -> Int {
        mockData[section].items.count
    }
    
    
    func typeSection(_ section: Int) -> String {
        mockData[section].type
    }
    
    
    func getItemTitle(_ section: Int, _ row: Int, circleScroll: Bool) -> String {
        if circleScroll {
            let indexRowForCirlceScroll = row % itemCount(section)
            return mockData[section].items[indexRowForCirlceScroll].direction
        } else {
            return mockData[section].items[row].direction
        }
    }
    
    
    func getHeaderTitle(_ section: Int) -> String {
        mockData[section].title
    }
    
    
    func moveItemToBeginning(_ indexPath: IndexPath) {
        let currentIndex = indexPath.row % mockData[indexPath.section].items.count
        let removeItem = mockData[indexPath.section].items.remove(at: currentIndex)
        mockData[indexPath.section].items.insert(removeItem, at: 0)
    }
    
    func calculateCounterForCircleScroll(_ indexPath: IndexPath) -> Bool {
        var calculate = false
        if indexPath.item == countItemsForSircle - 50 {
            countItemsForSircle = countItemsForSircle + 200
            calculate = true
        }
        return calculate
    }
}
