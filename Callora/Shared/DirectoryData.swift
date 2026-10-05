import Foundation

enum DirectoryConfig {
    static let appGroup = "group.com.callora.app"
    static let extensionIdentifier = "com.callora.app.CallDirectory"
    static let fileName = "directory.json"
}

struct DirectoryNumber: Codable, Identifiable, Hashable {
    var number: String
    var name: String
    var category: String
    var reports: Int
    var isSpam: Bool

    var id: String { number }
}

struct DirectorySnapshot: Codable {
    var numbers: [DirectoryNumber]
    var manualBlocks: [String]
    var blockedPrefixes: [String]
    var automaticBlocking: Bool

    static let empty = DirectorySnapshot(numbers: [], manualBlocks: [], blockedPrefixes: [], automaticBlocking: false)

    var blockedNumbers: [Int64] {
        let blocks = Set(manualBlocks + (automaticBlocking ? numbers.filter(\.isSpam).map(\.number) : []) +
            numbers.filter { number in blockedPrefixes.contains { number.number.hasPrefix($0) } }.map(\.number))
        return blocks.compactMap { Int64($0.dropFirst()) }.sorted()
    }

    var identificationEntries: [(number: Int64, label: String)] {
        let blocked = Set(blockedNumbers)
        return numbers.compactMap { entry in
            guard let value = Int64(entry.number.dropFirst()), !blocked.contains(value) else { return nil }
            return (value, entry.isSpam ? "Spam · \(entry.name)" : entry.name)
        }.sorted { $0.number < $1.number }
    }
}

enum PhoneNumber {
    // International numbers are stored in E.164 form. A country code is required.
    static func normalize(_ input: String) -> String? {
        let compact = input.filter { !$0.isWhitespace && !"()- .".contains($0) }
        guard compact.first == "+", compact.dropFirst().allSatisfy({ $0 >= "0" && $0 <= "9" }),
              (2...15).contains(compact.dropFirst().count), compact.dropFirst().first != "0" else { return nil }
        return compact
    }

    static func normalizePrefix(_ input: String) -> String? {
        guard let value = normalize(input), value.count >= 3 else { return nil }
        return value
    }
}

enum DirectoryFile {
    static var url: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: DirectoryConfig.appGroup)?
            .appendingPathComponent(DirectoryConfig.fileName)
    }

    static func load() -> DirectorySnapshot {
        guard let url, let data = try? Data(contentsOf: url),
              let snapshot = try? JSONDecoder().decode(DirectorySnapshot.self, from: data) else { return .empty }
        return snapshot
    }

    static func save(_ snapshot: DirectorySnapshot) throws {
        guard let url else { throw CocoaError(.fileNoSuchFile) }
        try JSONEncoder().encode(snapshot).write(to: url, options: .atomic)
    }
}
