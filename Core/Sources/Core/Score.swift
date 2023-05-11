import Foundation

// MARK: - Score

public struct Score: Codable, Hashable {
    public var id: Int
    public var date: DayDate
    public var word: String
    public var tries: [WordGuess]

    public init(id: Int, date: DayDate, word: String, tries: [WordGuess]) {
        self.id = id
        self.date = date
        self.word = word
        self.tries = tries
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.date = try container.decode(DayDate.self, forKey: .date)

        let word = try container.decode(String.self, forKey: .word)
        self.word = word

        let tries = try container.decode([String].self, forKey: .tries)
        self.tries = tries.map { .init(guess: $0, word: word) }
    }

    enum CodingKeys: CodingKey {
        case id
        case date
        case word
        case tries
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(word, forKey: .word)
        let tries = tries
            .map(\.letters)
            .map {
                $0.reduce(into: "") { partialResult, letter in
                    partialResult.append(letter.letter)
                }
            }
        try container.encode(tries, forKey: .tries)
    }
}

// MARK: - DayDate

public struct DayDate: Comparable, Codable, Hashable {
    public var year: Int
    public var month: Int
    public var day: Int
    
    /// The string value used for encoding/decoding.
    public var stringValue: String { String(format: "%04d-%02d-%02d", year, month, day) }
    
    /// The date formatted and localized to display to the user.
    public var displayValue: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: dateValue)
    }

    public var dateValue: Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        guard let date = Calendar.current.date(from: components) else {
            fatalError("Invalid date components to create a date")
        }

        return date
    }

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    public static func < (lhs: DayDate, rhs: DayDate) -> Bool {
        guard lhs.year >= rhs.year else { return true }
        guard lhs.month >= rhs.month else { return true }
        return lhs.day < rhs.day
    }

    public enum DecodingError: Error, Equatable {
        case invalidFormat(String)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let components = string.components(separatedBy: "-").compactMap(Int.init)
        guard components.count == 3 else { throw DecodingError.invalidFormat(string) }
        self.year = components[0]
        self.month = components[1]
        self.day = components[2]
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}
