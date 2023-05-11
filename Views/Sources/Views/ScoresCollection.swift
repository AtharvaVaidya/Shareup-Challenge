import Core
import Foundation
import OrderedCollections

struct ScoreData {
    let score: Score
    let obscured: Bool
}

typealias ScoresCollection = OrderedDictionary<Int, ScoreData>

extension OrderedDictionary where Key == Int, Value == ScoreData {
    init(_ values: [Value]) {
        self.init(uniqueKeysWithValues: values.map { ($0.score.id, $0) })
    }
}
