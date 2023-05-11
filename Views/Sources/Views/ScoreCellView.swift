import Core
import UIKit

public class ScoreCell: UICollectionViewCell {
    var score: Score?
    var obscured: Bool = false

    override public func updateConfiguration(using state: UICellConfigurationState) {
        contentConfiguration = ScoreContentConfiguration(score: score, obscured: obscured)
            .updated(for: state)
    }
}

private struct ScoreContentConfiguration: UIContentConfiguration, Hashable {
    var date: String
    var tries: [WordGuess]
    var word: String
    var obscured: Bool

    init(score: Score? = nil, obscured: Bool) {
        guard let score else {
            date = ""
            tries = []
            word = ""
            self.obscured = false
            return
        }
        date = score.date.stringValue
        tries = score.tries
        word = score.word
        self.obscured = obscured
    }

    func makeContentView() -> UIView & UIContentView {
        ScoreContentView(configuration: self)
    }

    func updated(for _: UIConfigurationState) -> Self { self }
}

private class ScoreContentView: UIView, UIContentView {
    private var _configuration: ScoreContentConfiguration
    var configuration: UIContentConfiguration {
        get { _configuration }
        set {
            guard let config = newValue as? ScoreContentConfiguration,
                  _configuration != config
            else { return }
            _configuration = config
            apply(configuration: config)
        }
    }

    private lazy var stackView: UIStackView = makeStackView()
    private lazy var dateLabel: UILabel = makeDateLabel()
    private var rowViews: [WordRowView] = []

    init(configuration: ScoreContentConfiguration) {
        _configuration = configuration
        super.init(frame: .zero)
        addConstrainedSubview(
            stackView,
            insets: .init(top: 16, left: 16, bottom: 16, right: 16),
            edges: .all
        )
        apply(configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func apply(configuration: ScoreContentConfiguration) {
        rowViews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        rowViews.removeAll()

        dateLabel.text = configuration.date
        configuration.tries.forEach { word in
            let row = WordRowView(word: word, obscured: configuration.obscured)
            stackView.addArrangedSubview(row)
            rowViews.append(row)
        }

        setNeedsLayout()
    }

    private func makeStackView() -> UIStackView {
        let view = UIStackView(arrangedSubviews: [dateLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .leading
        return view
    }

    private func makeDateLabel() -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingMiddle
        view.allowsDefaultTighteningForTruncation = true
        view.adjustsFontForContentSizeCategory = true
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.textColor = .label
        return view
    }
}


#if DEBUG

    import SwiftUI

    struct ScoreCellView_Preview: PreviewProvider {
        static var previews: some View {
            CellView().previewLayout(.fixed(width: 300, height: 150))
        }
    }

    private struct CellView: UIViewRepresentable {
        func makeUIView(context _: Context) -> ScoreContentView {
            ScoreContentView(configuration: .init(score: .init(
                id: 1,
                date: .init(year: 2022, month: 3, day: 27),
                word: "nymph",
                tries: ["train", "ponds", "blume", "nymph"].map({
                    WordGuess(guess: $0, word: "nymph")
                })
            ), obscured: Bool.random()))
        }

        func updateUIView(_: ScoreContentView, context _: Context) {}
    }
#endif
