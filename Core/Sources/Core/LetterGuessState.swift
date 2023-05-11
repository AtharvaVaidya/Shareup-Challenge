//
//  LetterGuessState.swift
//  
//
//  Created by Atharva Vaidya on 11/05/2023.
//

import Foundation

public enum LetterGuessState: Codable, Equatable, Hashable {
    ///The letter doesn't exist in the word.
    case wrong
    
    ///The letter exists in the word, but the guess wasn't at the right position.
    case existsInWord
    
    ///The letter and its position were guessed correctly.
    case correct
}
