//
//  WordDatabase.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 15.08.2022.
//

import Foundation
import RealmSwift

final class WordDatabase {
    
    var documentsFileURL: URL? {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url.appendingPathComponent("words.realm")
        }
        return nil
    }
    
    private var realm: Realm? {
        guard let url = documentsFileURL else {
            return nil
        }
        return try? Realm(fileURL: url)
    }
    
    init(){
        if let documentsFileURL = documentsFileURL {
            if FileManager.default.fileExists(atPath: documentsFileURL.path){
                if let bundleURL = Bundle.main.url(forResource: "words", withExtension: "realm"){
                    try? FileManager.default.copyItem(at: bundleURL, to: documentsFileURL)
                }
            }
        }
    }
    
    func retrieveAndConsumeRandomWord() -> String {
        let words = realm?
            .objects(Word.self)
            .filter { $0.item.count == 5 &&  !$0.skip }
        
        let wordsArray = words?.compactMap { $0.item } ?? []
        
        let randomWord =  wordsArray.randomElement() ?? ""
        markAsSkip(word: randomWord)
        return randomWord
    }
    
    func retrieveWords() -> [String] {
    
        let words = realm?
            .objects(Word.self)
            .filter { $0.item.count == 5 && !$0.skip }
        
        return words?.compactMap { $0.item } ?? []
    }
    
    private func markAsSkip(word: String ){
        let word = realm?
            .objects(Word.self)
            .filter{ word == $0.item }
            .first
        // always write closure
        // db's different thread override avoid
        // farklı thread'lerde yazmalar birbirini ezmemesi için
        try? realm?.write{
            word?.skip = true
        }
    }
}
