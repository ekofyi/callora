import CallKit
import Combine
import Foundation

@MainActor
final class DirectoryStore: ObservableObject {
    @Published private(set) var snapshot: DirectorySnapshot
    @Published var extensionEnabled = false
    @Published var statusMessage: String?

    init() {
        snapshot = DirectoryFile.load()
    }

    func lookup(_ input: String) -> DirectoryNumber? {
        guard let number = PhoneNumber.normalize(input) else { return nil }
        return snapshot.numbers.first { $0.number == number }
    }

    func isBlocked(_ number: String) -> Bool {
        snapshot.manualBlocks.contains(number) ||
        snapshot.blockedPrefixes.contains { number.hasPrefix($0) } ||
        (snapshot.automaticBlocking && snapshot.numbers.contains { $0.number == number && $0.isSpam })
    }

    func addBlock(_ input: String) -> Bool {
        guard let number = PhoneNumber.normalize(input) else { return false }
        update { $0.manualBlocks = Array(Set($0.manualBlocks + [number])).sorted() }
        return true
    }

    func removeBlock(_ number: String) {
        update { $0.manualBlocks.removeAll { $0 == number } }
    }

    func addPrefix(_ input: String) -> Bool {
        guard let prefix = PhoneNumber.normalizePrefix(input) else { return false }
        update { $0.blockedPrefixes = Array(Set($0.blockedPrefixes + [prefix])).sorted() }
        return true
    }

    func removePrefix(_ prefix: String) {
        update { $0.blockedPrefixes.removeAll { $0 == prefix } }
    }

    func setAutomaticBlocking(_ enabled: Bool) {
        update { $0.automaticBlocking = enabled }
    }

    func importNumbers(_ entries: [DirectoryNumber]) {
        update { state in
            var indexed = Dictionary(uniqueKeysWithValues: state.numbers.map { ($0.number, $0) })
            for entry in entries where PhoneNumber.normalize(entry.number) == entry.number {
                indexed[entry.number] = entry
            }
            state.numbers = indexed.values.sorted { $0.number < $1.number }
        }
    }

    func refreshStatus() {
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: DirectoryConfig.extensionIdentifier) { status, error in
            Task { @MainActor in
                self.extensionEnabled = status == .enabled
                if let error { self.statusMessage = error.localizedDescription }
            }
        }
    }

    func reload() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: DirectoryConfig.extensionIdentifier) { error in
            Task { @MainActor in
                if let error {
                    self.statusMessage = "Enable Callora in Settings > Phone > Call Blocking & Identification. \(error.localizedDescription)"
                } else {
                    self.statusMessage = "Identification and block lists were updated."
                    self.refreshStatus()
                }
            }
        }
    }

    private func update(_ change: (inout DirectorySnapshot) -> Void) {
        var next = snapshot
        change(&next)
        do {
            try DirectoryFile.save(next)
            snapshot = next
            reload()
        } catch {
            statusMessage = "Failed to save the list: \(error.localizedDescription)"
        }
    }
}
