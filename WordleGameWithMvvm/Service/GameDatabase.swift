//
//  GameDatabase.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 15.08.2022.
//

import Foundation
import RealmSwift

final class GameDatabase {
    
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
    func retrieveGames() -> [Game]{
       return realm?
            .objects(Game.self).compactMap { $0 } ?? []
    }
    func initializeGame() -> Game {
        var game = Game()
        
        // bu obje artık realmDb'ye ait bir obje degisiklikleri closure icinde
        // yapabilirsin aksi halde algılamaz
       try? realm?.write {
            realm?.add(game)
        }
        return game
    }
    
    func addWordToGame(game: Game, word: String){
        var currentWords: List<String> = List<String>()
       
        
        try? realm?.write {
            game.words.append(word)
         }
        
    }
    func updateGameStatus(game: Game, isSuccess: Bool){
        try? realm?.write{
            game.isSuccess = isSuccess
            
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
