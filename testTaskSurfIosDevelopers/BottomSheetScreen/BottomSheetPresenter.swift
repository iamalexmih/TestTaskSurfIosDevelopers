//
//  Presenter.swift
//  testTaskSurfIosDevelopers
//
//  Created by Алексей Попроцкий on 06.02.2023.
//

import Foundation


protocol PresenterProtocol: AnyObject {
//    init(view: ViewControllerProtocol, router: RouterProtocol, humanNumber: Int)
    func buttonEqualWasPress()
    func buttonMoreWasPress()
    func buttonLessWasPress()
}
