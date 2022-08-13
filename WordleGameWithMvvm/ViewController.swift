//
//  ViewController.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 13.08.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        provideWord(input: "kitap")
    }
    
    private let words = [
    "biber",
   "gazoz",
    "helva",
   
   "hurma",
    "swift",
    "kitap",
    "katip",
    "kasma"
    ]
    
    private var inputWords : [String] = []
    private let targetWord  = "kitap"
    private let alphabet: CharacterSet = {
        var characterSet = CharacterSet.lowercaseLetters
        characterSet.insert(charactersIn: "çüğşıö")
        return characterSet
    }()
    
    private var inputCharacters: [String] = []
    
    private var currentInput: String = "" {
        // set edildikten sonra buraya girecek o yuzden burdan once bi kontrol gerek
        didSet {
            if currentInput.count == 5 {
                provideWord(input: currentInput)
            }
        }
    }
    
    private func tryToProvide(input: String ) {
        let lastCharacter  = input[input.index(input.startIndex, offsetBy: input.count - 1)]
        guard !inputCharacters.contains(String(lastCharacter)) else {
            return
        }
        
        guard alphabet.isSuperset(of: CharacterSet(charactersIn: input )) else {
            return
        }
        
        currentInput = input
    }
    
    private func provideWord(input : String){
        guard words.contains(input) else {
            print("kelime bulunamıyor ")
            return
        }
        
        guard !inputWords.contains(input) else {
            print("Daha once denedin kelimeyi ")
            return
        }
        
        inputWords.append(targetWord)
        
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
        print("eslesen index \(matchedIndexes)")
        print("eslesmeye yakın \(nearlyMatchedIndexes)")
        
    }

}

