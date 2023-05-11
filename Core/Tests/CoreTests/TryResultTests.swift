@testable import Core
import XCTest

final class TryResultTests: XCTestCase {
    func result(for guess: String, word: String) -> [LetterResult] {
        WordGuess(guess: guess, word: word).letters.map({ $0.letterResult })
    }
    
    func testResultForTryAndWord() throws {
        XCTAssertEqual(
            [.wrongPosition, .correct, .wrong, .wrong, .wrong],
            result(for: "parry", word: "lapse")
        )
    }
}
