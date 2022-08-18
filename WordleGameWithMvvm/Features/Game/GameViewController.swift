//
//  ViewController.swift
//  WordleGameWithMvvm
//
//  Created by Mustafa Çiçek on 13.08.2022.
//

import UIKit

class GameViewController: UIViewController {
    private let model = GameViewModel()
    
    @IBOutlet private weak var baseStackView: UIStackView!
    
    @IBOutlet private weak var wordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        model.reloadTargetWord()
        addStackViewForNewWord()
        
        model.onCharacterSucces = { [weak self] word in
            self?.addCharacterBox(word: word)
        }
        
        model.onInputComplete = { [weak self] InputComplete in
            guard let lastStackView = self?.baseStackView.arrangedSubviews.last as? UIStackView else {
                return
            }
            
            for i in 0..<lastStackView.arrangedSubviews.count {
                let label = lastStackView.arrangedSubviews[i] as? UILabel
                if InputComplete.matchedIndexes.contains(i) {
                    label?.textColor = .green
                    
                }else if InputComplete.nearlyMatchedIndexes.contains(i) {
                    label?.textColor = .yellow
                }
            }
            self?.addStackViewForNewWord()
            
        }
        model.onError = { [weak self] error in
            guard let self = self else { return }
            let message: String
            switch error {
            case .notValidCharacter:
                message = "Not valid character."
            case .notInDictionary:
                message = "Not in dictionary."
            case .inputAlreadyExists:
                message = "Input already exists."
            }
            
            self.customAlert(title: "Error", message: message)
            
            
        }
        model.onGameOver = { [weak self] isSuccess in
            
            self?.customAlert(title: "Game Finished!", message: isSuccess ? "Succesfully :)": "Fail :( ")
        }
    }
    
    private func addCharacterBox(word: String){
        guard let lastStackView = baseStackView.arrangedSubviews.last as? UIStackView else {
            return
        }
        
        lastStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        
        for character in Array(word) {
            let label = UILabel()
            label.font = .systemFont(ofSize: 32)
            label.text = String(character)
            lastStackView.addArrangedSubview(label)
        }
    }
    
    private func addStackViewForNewWord(){
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.distribution = .fillEqually
        baseStackView.addArrangedSubview(stackView)
        
        wordTextField.text = ""
    }
    
    @objc func textDidChange(_ sender: UITextField){
        // if text did change, add stack view
        model.tryToProvide(input: sender.text!)
    }
    
   

}

