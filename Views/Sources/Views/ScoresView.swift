import Combine
import Core
import OrderedCollections
import UIKit

private enum Section {
    case scores
}

public class ScoresViewController: UIViewController {
    private let scoresPublisher: AnyPublisher<[Score], Error>
    private var scores = ScoresCollection()
    private var cancellables = Set<AnyCancellable>()

    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Int> =
        makeDataSource()

    private var didApplyInitialSnapshot = false

    public init(scoresPublisher: AnyPublisher<[Score], Error>) {
        self.scoresPublisher = scoresPublisher
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.addConstrainedSubview(collectionView)
        
        collectionView.delegate = self
        
        scoresPublisher
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: onReceiveScores)
            .store(in: &cancellables)
        
        //Navbar setup
        title = "Wordle Scores"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension ScoresViewController {
    func makeCollectionView() -> UICollectionView {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Int> {
        let cellRegistration = UICollectionView.CellRegistration<ScoreCell, ScoreData> { cell, _, scoreData in
            cell.score = scoreData.score
            cell.obscured = scoreData.obscured
        }

        return UICollectionViewDiffableDataSource<Section, Int>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, itemIdentifier in
            let score: ScoreData? = self?.scores[itemIdentifier]
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: score
            )
        }
    }

    var onReceiveScores: ([Score]) -> Void {
        { [weak self] (scores: [Score]) in
            guard let self else { return }
            let animate = didApplyInitialSnapshot
            didApplyInitialSnapshot = true
            self.scores = ScoresCollection(scores.map({ ScoreData(score: $0, obscured: true) }))
            var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
            snapshot.appendSections([.scores])
            snapshot.appendItems(scores.map(\.id))
            dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension ScoresViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scoreData = Array(scores)[indexPath.item].value
        let newScoreData = ScoreData(score: scoreData.score, obscured: !scoreData.obscured)
        scores[scoreData.score.id] = newScoreData
      
        var snapshot = dataSource.snapshot()
        if #available(iOS 15.0, *) {
            snapshot.reconfigureItems([newScoreData.score.id])
        } else {
            // Fallback on earlier versions
            snapshot.reloadItems([newScoreData.score.id])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

#if DEBUG

    import SwiftUI

    struct ScoresView_Preview: PreviewProvider {
        static var previews: some View {
            ScoresView()
        }
    }

    struct ScoresView: UIViewControllerRepresentable {
        func makeUIViewController(context _: Context) -> some UIViewController {
            ScoresViewController(scoresPublisher: Backend.test.typeErasedGetAllScores)
        }

        func updateUIViewController(_: UIViewControllerType, context _: Context) {}
    }

#endif
