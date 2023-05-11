//
//  WordRowView.swift
//  
//
//  Created by Atharva Vaidya on 11/05/2023.
//

import UIKit
import Core

final class WordRowView: UIView {
    private var word: WordGuess
    private lazy var letterViews: [LetterView] = word.letters.map { LetterView(letter: String($0.letter), letterGuessState: $0.letterGuessState) }
    private lazy var stackView: UIStackView = makeStackView()
    private var obscured: Bool

    init(word: WordGuess, obscured: Bool) {
        precondition(word.letters.count == 5)
        self.word = word
        self.obscured = obscured
        super.init(frame: .zero)
        addConstrainedSubview(stackView)
        setUpContraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeStackView() -> UIStackView {
        let view = UIStackView(arrangedSubviews: letterViews)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.axis = .horizontal
        view.spacing = 2
        view.alignment = .center
        view.distribution = .fillEqually
        return view
    }

    private func setUpContraints() {
        let first = letterViews[0]
        let constraints = letterViews.dropFirst().flatMap { lv in
            let w = lv.widthAnchor.constraint(equalTo: first.widthAnchor)
            let h = lv.heightAnchor.constraint(equalTo: lv.widthAnchor)
            return [w, h]
        }
        NSLayoutConstraint.activate(constraints)
    }
}
