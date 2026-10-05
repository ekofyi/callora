import SwiftUI

@main
struct CalloraApp: App {
    @StateObject private var store = DirectoryStore()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(store)
                .tint(Color.brand)
        }
    }
}
