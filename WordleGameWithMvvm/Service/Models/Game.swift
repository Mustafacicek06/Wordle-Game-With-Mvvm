//
//  Game.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 16.08.2022.
//

import Foundation
import RealmSwift

@objcMembers class Game: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var date: Date = Date()
    dynamic var words: List<String> = List<String>()
    dynamic var isSuccess: Bool = false
    
    convenience init(id: String,
                     date: Date,
                     words: List<String>,
                     isSuccess: Bool){
        self.init()
        self.date = date
        self.words = words
        self.isSuccess = isSuccess
        
    }
    
}
