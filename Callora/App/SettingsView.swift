import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct PremiumView: View {
    @State private var showingOffer = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                PageHeader(eyebrow: "Premium", title: "Upgrade your protection", subtitle: "Get a more complete and peaceful Callora experience.")
                premiumHero
                VStack(alignment: .leading, spacing: 13) {
                    Text("Premium benefits").font(.system(size: 21, weight: .bold, design: .rounded)).foregroundStyle(Color.ink)
                    benefit("shield.checkered", "Stronger spam protection", "Filter suspicious calls with higher priority.")
                    benefit("person.2.fill", "Family group", "Share protection with the people closest to you.")
                    benefit("bolt.fill", "Faster database updates", "Get the latest safety signals first.")
                    benefit("sparkles", "An uninterrupted experience", "Enjoy Callora with all premium features.")
                }
                Button { showingOffer = true } label: {
                    Text("Coba Premium sekarang")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.brand, in: RoundedRectangle(cornerRadius: 17))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color.canvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .alert("Premium is coming soon", isPresented: $showingOffer) {
            Button("Mengerti", role: .cancel) { }
        } message: {
            Text("Premium offers and payments will be available in a future update.")
        }
    }

    private var premiumHero: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "crown.fill").font(.title2).foregroundStyle(.yellow)
                Spacer()
                Text("PREMIUM").font(.caption.weight(.bold)).tracking(1.4).foregroundStyle(.white.opacity(0.75))
            }
            Text("Keep your calls\npeaceful.")
                .font(.system(size: 31, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text("One upgrade for family protection and more complete spam control.")
                .font(.subheadline).foregroundStyle(.white.opacity(0.8))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [Color(red: 0.10, green: 0.58, blue: 1.0), Color(red: 0.02, green: 0.35, blue: 0.88)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 26))
    }

    private func benefit(_ symbol: String, _ title: String, _ subtitle: String) -> some View {
        HStack(spacing: 14) {
            IconTile(symbol: symbol)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.bold)).foregroundStyle(Color.ink)
                Text(subtitle).font(.caption).foregroundStyle(Color.muted)
            }
            Spacer()
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 19))
    }
}

struct MenuView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                PageHeader(eyebrow: "Menu", title: "Profile & app info", subtitle: "Manage your account and learn more about Callora.")
                Card {
                    HStack(spacing: 14) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 42)).foregroundStyle(Color.brand)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Callora user").font(.headline).foregroundStyle(Color.ink)
                            Text("Local profile on this device").font(.caption).foregroundStyle(Color.muted)
                        }
                    }
                }
                NavigationLink { SettingsView() } label: {
                    menuRow("Caller ID & database", subtitle: "Settings and number import", symbol: "gearshape.fill")
                }
                .buttonStyle(.plain)
                NavigationLink { AboutView() } label: {
                    menuRow("About Callora", subtitle: "App information and privacy", symbol: "info.circle.fill")
                }
                .buttonStyle(.plain)
                NavigationLink { LanguageSettingsView() } label: {
                    menuRow("Language", subtitle: "English / Indonesia", symbol: "globe")
                }
                .buttonStyle(.plain)
                Card {
                    HStack {
                        Text("Version").font(.subheadline).foregroundStyle(Color.muted)
                        Spacer()
                        Text("0.1.0").font(.subheadline.weight(.semibold)).foregroundStyle(Color.ink)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color.canvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private func menuRow(_ title: String, subtitle: String, symbol: String) -> some View {
        HStack(spacing: 14) {
            IconTile(symbol: symbol)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.bold)).foregroundStyle(Color.ink)
                Text(subtitle).font(.caption).foregroundStyle(Color.muted)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(Color.muted)
        }
        .padding(20)
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
    }
}

struct LanguageSettingsView: View {
    @AppStorage("appLanguage") private var appLanguage = "English"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PageHeader(eyebrow: "Menu", title: "Language", subtitle: "Choose the language used by Callora.")
                Card {
                    Picker("Language", selection: $appLanguage) {
                        Text("English").tag("English")
                        Text("Indonesia").tag("Indonesia")
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
                Text("English is the default language. Your choice is saved on this device.")
                    .font(.caption)
                    .foregroundStyle(Color.muted)
            }
            .padding(20)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PageHeader(eyebrow: "Menu", title: "About Callora", subtitle: "Safer calls, starting from your device.")
                Card {
                    IconTile(symbol: "waveform.path.ecg.rectangle.fill", size: 56)
                    Text("Callora helps you identify and block calls using a local database on your device.")
                        .font(.subheadline).foregroundStyle(Color.ink).padding(.top, 16)
                    Text("Number data, block rules, and imported databases are stored locally in Callora's App Group.")
                        .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 8)
                }
                Card {
                    Label("Privacy first", systemImage: "lock.shield.fill")
                        .font(.headline).foregroundStyle(Color.ink)
                    Text("Callora does not send your block list to a server.")
                        .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 10)
                }
            }
            .padding(20)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle("About Callora")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView: View {
    @EnvironmentObject private var store: DirectoryStore
    @State private var showingImporter = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                PageHeader(eyebrow: "Menu", title: "Caller ID & database", subtitle: "Set up identification and manage your number database.")
                Card {
                    HStack(spacing: 13) {
                        IconTile(symbol: store.extensionEnabled ? "checkmark.shield.fill" : "shield.fill")
                        VStack(alignment: .leading, spacing: 6) {
                            Text(store.extensionEnabled ? "Callora is enabled" : "Callora is disabled")
                                .font(.headline).foregroundStyle(Color.ink)
                            StatusPill(title: store.extensionEnabled ? "Ready to use" : "Needs enabling", symbol: store.extensionEnabled ? "checkmark.circle.fill" : "info.circle.fill")
                        }
                    }
                    Text("Open Settings > Phone > Call Blocking & Identification, then enable Callora.")
                        .font(.subheadline).foregroundStyle(Color.muted)
                        .fixedSize(horizontal: false, vertical: true).padding(.top, 17)
                    FilledAction(title: "Open Settings", symbol: "arrow.up.right") {
                        if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
                    }
                    .padding(.top, 18)
                }
                Card {
                    HStack(spacing: 14) {
                        IconTile(symbol: "square.stack.3d.up.fill")
                        VStack(alignment: .leading, spacing: 3) {
                            Text("\(store.snapshot.numbers.count) numbers available").font(.headline).foregroundStyle(Color.ink)
                            Text("Your local list").font(.caption).foregroundStyle(Color.muted)
                        }
                    }
                    Text("Import a JSON file containing numbers in international format.")
                        .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 16)
                    FilledAction(title: "Import database", symbol: "square.and.arrow.down.fill") { showingImporter = true }
                        .padding(.top, 18)
                }
            }
            .padding(.horizontal, 20).padding(.bottom, 32)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle("Caller ID & database")
        .navigationBarTitleDisplayMode(.inline)
        .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.json]) { result in
            do {
                let url = try result.get()
                guard url.startAccessingSecurityScopedResource() else {
                    store.statusMessage = "Unable to access the selected file."
                    return
                }
                defer { url.stopAccessingSecurityScopedResource() }
                let entries = try JSONDecoder().decode([DirectoryNumber].self, from: Data(contentsOf: url))
                store.importNumbers(entries)
            } catch {
                store.statusMessage = "Failed to import database: \(error.localizedDescription)"
            }
        }
    }
}
