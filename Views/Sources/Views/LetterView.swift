//
//  LetterView.swift
//
//
//  Created by Atharva Vaidya on 11/05/2023.
//

import UIKit
import Core

final class LetterView: UIView {
    private var letter: String
    private var letterGuessState: LetterGuessState
    private lazy var label: UILabel = makeLabel()

    init(letter: String, letterGuessState: LetterGuessState) {
        precondition(letter.utf8.count == 1)
        self.letter = letter
        self.letterGuessState = letterGuessState
        super.init(frame: .zero)
        addConstrainedSubview(label)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.numberOfLines = 1
        view.allowsDefaultTighteningForTruncation = false
        view.adjustsFontForContentSizeCategory = true
        view.textAlignment = .center
        view.textColor = .label
        view.backgroundColor = .systemFill
        view.text = letter.uppercased()
        let baseFont = UIFont.preferredFont(forTextStyle: .body)
        
        guard let fontDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitBold) else {
            view.font = baseFont
            return view
        }
        
        view.font = UIFont(descriptor: fontDescriptor, size: baseFont.pointSize)
        return view
    }
}
