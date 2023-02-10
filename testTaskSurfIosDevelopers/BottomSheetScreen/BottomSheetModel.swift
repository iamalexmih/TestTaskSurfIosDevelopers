//
//  Model.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import Foundation


struct SectionModel {
    let type: String
    let title: String
    var items: [DirectionItems]
}



struct DirectionItems {
    let direction: String
}


