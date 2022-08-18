//
//  Word.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 15.08.2022.
//

import Foundation
import RealmSwift

@objcMembers class Word: Object {
    dynamic var item: String = ""
    dynamic var skip: Bool = false
    
    convenience init(item: String, skip: Bool = false){
        self.init()
        self.item = item
        self.skip = false
    }
}
