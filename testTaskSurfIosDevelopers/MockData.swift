//
//  MockData.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import Foundation


class MockData {
    
    static let shared = MockData()
    private init() { }
    
    
    private let directionItems: [DirectionItems] =  [
            DirectionItems(direction: "IOS"),
            DirectionItems(direction: "Android"),
            DirectionItems(direction: "Design"),
            DirectionItems(direction: "QA"),
            DirectionItems(direction: "Flutter"),
            DirectionItems(direction: "PM")
        ]
    
    private let textOneHeader = "Работай"
    private let textTwoHeader = "Получай"
    
    
    func getSections() -> [SectionModel] {
        let oneSection = SectionModel(type: "OneRow", title: textOneHeader, items: directionItems)
        let twoSection = SectionModel(type: "TwoRows", title: textTwoHeader, items: directionItems)
        
        return [oneSection, twoSection]
    }
}
