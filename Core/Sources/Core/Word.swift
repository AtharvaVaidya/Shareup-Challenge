//
//  Word.swift
//
//
//  Created by Atharva Vaidya on 11/05/2023.
//

import Foundation

// MARK: - Letter

public struct Letter: Codable, Equatable, Hashable {
    public let letter: String
    public let letterGuessState: LetterResult

    public init(letter: String, letterGuessState: LetterResult) {
        self.letter = letter
        self.letterGuessState = letterGuessState
    }
}

// MARK: - WordGuess

public struct WordGuess: Codable, Equatable, Hashable {
    public let letters: [Letter]

    public init(letters: [Letter]) {
        self.letters = letters
    }
    
    /// Initialises the `WordGuess` object with the guess and the word that was being guessed.
    /// Example: The Wordle word is "Train", and the user guessed "Trope". So `guess` would be "Trope", and "Word" would be the `word`.
    /// - Parameters:
    ///   - guess: The user's guess
    ///   - word: The Wordle word that was being guessed.
    public init(guess: String, word: String) {
        self.letters = guess.indices.map({ index in
            Letter(
                letter: String(guess[index]),
                letterGuessState: WordGuess.letterGuessStateFor(letter: guess[index], letterOffset: index, word: word)
            )
        })
    }
    
    private static func letterGuessStateFor(letter: Character, letterOffset: String.Index, word: String) -> LetterResult {
        if word[letterOffset] == letter {
            return .correct
        } else if word.contains(letter) {
            return .wrongPosition
        } else {
            return .wrong
        }
    }
}
