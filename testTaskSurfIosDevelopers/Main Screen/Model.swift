//
//  Model.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import Foundation


struct SectionModel: Hashable {
    let type: String
    let title: String
    let items: [DirectionItems]
}



struct DirectionItems: Hashable {
    let direction: String
}


