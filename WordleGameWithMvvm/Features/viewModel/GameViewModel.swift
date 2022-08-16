//
//  GameViewModel.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 13.08.2022.
//

import Foundation


struct InputComplete {
    let word: String
    let matchedIndexes: [Int]
    let nearlyMatchedIndexes: [Int]
}

enum WordleError: Error {
    case notValidCharacter
    case notInDictionary
    case inputAlreadyExists
    
}

final class GameViewModel {
    
    private enum Constant {
        
         static let words = [
        "biber",
       "gazoz",
        "helva",
       "hurma",
        "swift",
        "kitap",
        "katip",
        "kasma"
        ]
        
         static let alphabet: CharacterSet = {
            var characterSet = CharacterSet.lowercaseLetters
            characterSet.insert(charactersIn: "çüğşıö")
            return characterSet
        }()
        
    }
    
    var onCharacterSucces: ((String) -> Void)? = nil
    var onInputComplete: ((InputComplete) -> Void)? = nil
    var onError: ((WordleError) -> Void)? = nil
    var onGameOver: ((Bool) -> Void)? = nil
    
   
    private var targetWord : String? {
        didSet {
            inputWords.removeAll()
            inputCharacters.removeAll()
            currentInput = ""
        }
    }
    
    private var inputWords : [String] = []
   
    
    private var inputCharacters: [String] = []
    
    private let database = GameDatabase()
    private var currentGame: Game?
    
    // MARK: Public methods
    
    func reloadTargetWord(){
        
        targetWord = database.retrieveAndConsumeRandomWord()
        currentGame = database.initializeGame()
    
    }
    
    func tryToProvide(input: String ) {
       
        
        guard Constant.alphabet.isSuperset(of: CharacterSet(charactersIn: input )) else {
            onError?(.notValidCharacter)
            return
        }
        
        currentInput = input
    }
    
    // MARK: Private methods
    
    private var currentInput: String = "" {
        // set edildikten sonra buraya girecek o yuzden burdan once bi kontrol gerek
        didSet {
            onCharacterSucces?(currentInput)
            
            if currentInput.count == 5 {
                provideWord(input: currentInput)
            }
        }
    }
    
   
    
    private func provideWord(input : String){
        // target word yoksa islem yapma
        guard let targetWord = targetWord else {
          
            return
        }
        
        guard  database.retrieveWords().contains(input) else {
            onError?(.notInDictionary)
            return
        }
        
        guard !inputWords.contains(input) else {
            onError?(.inputAlreadyExists)
            return
        }
        
        inputWords.append(targetWord )
        
        var matchedIndexes: [Int] = []
        var nearlyMatchedIndexes: [Int] = []
        
        for i in 0..<5 {
            let inputCharacter = input[input.index(input.startIndex, offsetBy: i)]
            let targetCharacter = targetWord[targetWord.index(targetWord.startIndex, offsetBy: i)]
            
            inputCharacters.append(String(inputCharacter))
            
            if inputCharacter == targetCharacter {
                matchedIndexes.append(i)
            }
            else if ( targetWord.contains(inputCharacter)) {
                nearlyMatchedIndexes.append(i)
            }
            else{
                print("karakter bulunamadı: \(inputCharacter)")
            }
        
        }
        if let game = currentGame {
            database.addWordToGame(game: game,word: input)

        }
        
        onInputComplete?(InputComplete(word: input, matchedIndexes: matchedIndexes, nearlyMatchedIndexes: nearlyMatchedIndexes))
        let isSuccess = inputWords.contains(targetWord)
        let isComplete = inputWords.count == 6
        if isSuccess {
            onGameOver?(true)
            if let game = currentGame {
                database.updateGameStatus(game: game,isSuccess: true)
            }
        } else {
            onGameOver?(false)
            if let game = currentGame {
                database.updateGameStatus(game: game,isSuccess: false)
            }
        }
      
        
    }
}
