//
//  LetterView.swift
//
//
//  Created by Atharva Vaidya on 11/05/2023.
//

import Core
import UIKit

final class LetterView: UIView {
    private var letter: String
    private var letterGuessState: LetterResult
    private var obscured: Bool
    
    private lazy var label: UILabel = makeLabel()

    init(letter: String, letterGuessState: LetterResult, obscured: Bool) {
        precondition(letter.utf8.count == 1)
        self.letter = letter
        self.letterGuessState = letterGuessState
        self.obscured = obscured
        super.init(frame: .zero)
        addConstrainedSubview(label, insets: .init(top: 8, left: 8, bottom: 8, right: 8))
        self.backgroundColor = backgroundColorFor(guessState: letterGuessState)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = obscured ? 0 : 1
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.numberOfLines = 1
        view.allowsDefaultTighteningForTruncation = false
        view.adjustsFontForContentSizeCategory = true
        view.textAlignment = .center
        view.textColor = .white
        view.backgroundColor = .clear
        view.text = letter.uppercased()
        view.font = UIFont.preferredFont(forTextStyle: .body).bold()
        return view
    }

    private func backgroundColorFor(guessState: LetterResult) -> UIColor {
        switch guessState {
        case .correct:
            return .systemGreen
        case .wrongPosition:
            return .systemYellow
        case .wrong:
            return .systemGray
        }
    }
}
