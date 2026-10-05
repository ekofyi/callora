import SwiftUI

struct MainView: View {
    @EnvironmentObject private var store: DirectoryStore

    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Home", systemImage: "house.fill") }
            NavigationStack { ProtectionView() }
                .tabItem { Label("Protection", systemImage: "shield.lefthalf.filled") }
            NavigationStack { PremiumView() }
                .tabItem { Label("Premium", systemImage: "crown.fill") }
            NavigationStack { MenuView() }
                .tabItem { Label("Menu", systemImage: "line.3.horizontal") }
        }
        .tint(.brand)
        .onAppear { store.refreshStatus() }
        .alert("Callora", isPresented: Binding(get: { store.statusMessage != nil }, set: { if !$0 { store.statusMessage = nil } })) {
            Button("OK") { store.statusMessage = nil }
        } message: {
            Text(store.statusMessage ?? "")
        }
    }
}

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                HStack(spacing: 12) {
                    IconTile(symbol: "waveform.path.ecg.rectangle.fill", size: 46)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Callora").font(.system(size: 22, weight: .bold, design: .rounded)).foregroundStyle(Color.ink)
                        Text("Know every call").font(.caption).foregroundStyle(Color.muted)
                    }
                    Spacer()
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(Color.brand)
                        .accessibilityHidden(true)
                }

                NavigationLink { SearchView() } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass").foregroundStyle(Color.brand)
                        Text("Search an unknown number").foregroundStyle(Color.muted)
                        Spacer()
                    }
                    .font(.subheadline)
                    .padding(18)
                    .background(.white, in: RoundedRectangle(cornerRadius: 18))
                    .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Color.line))
                }
                .buttonStyle(.plain)

                banner

                VStack(alignment: .leading, spacing: 14) {
                    SectionHeading(title: "Recent calls", subtitle: "Your latest calls")
                    Card {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.title2).foregroundStyle(Color.brand)
                        Text("No recent calls")
                            .font(.headline).foregroundStyle(Color.ink).padding(.top, 10)
                        Text("iPhone call history is not available to Callora.")
                            .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 5)
                    }
                    NavigationLink { RecentCallsView() } label: {
                        HStack {
                            Text("Show more")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.brand)
                        .padding(.horizontal, 4)
                    }
                }

                VStack(alignment: .leading, spacing: 14) {
                    SectionHeading(title: "Discover", subtitle: "Understand and manage calls with confidence")
                    HStack(alignment: .top, spacing: 10) {
                        discoverItem("Tutorial", symbol: "book.closed.fill", destination: DiscoverView(kind: .tutorial))
                        discoverItem("Announcement", symbol: "megaphone.fill", destination: DiscoverView(kind: .announcement))
                        discoverItem("How to report calls", symbol: "flag.fill", destination: DiscoverView(kind: .report))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 32)
        }
        .background(Color.canvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var banner: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 26)
                .fill(LinearGradient(colors: [Color(red: 0.08, green: 0.58, blue: 1.0), Color(red: 0.02, green: 0.35, blue: 0.88)], startPoint: .topLeading, endPoint: .bottomTrailing))
            Circle().strokeBorder(.white.opacity(0.18), lineWidth: 28)
                .frame(width: 170, height: 170).offset(x: 230, y: -65)
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: "waveform.path")
                    .font(.title2).foregroundStyle(.white)
                Text("Know who is\ncalling.")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Search unknown numbers before answering.")
                    .font(.subheadline).foregroundStyle(.white.opacity(0.8))
            }
            .padding(22)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1.8, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .accessibilityElement(children: .combine)
    }

    private func discoverItem<Destination: View>(_ title: String, symbol: String, destination: Destination) -> some View {
        NavigationLink { destination } label: {
            VStack(alignment: .leading, spacing: 14) {
                IconTile(symbol: symbol, size: 38)
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.ink)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 124)
            .background(.white, in: RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}

struct RecentCallsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PageHeader(eyebrow: "History", title: "Recent calls", subtitle: "Your latest calls")
                Card {
                    IconTile(symbol: "phone.arrow.down.left.fill")
                    Text("No calls to display")
                        .font(.headline).foregroundStyle(Color.ink).padding(.top, 14)
                    Text("iOS does not provide phone call history to apps. You can still search numbers manually from Home.")
                        .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 6)
                }
            }
            .padding(20)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle("Recent calls")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DiscoverView: View {
    enum Kind {
        case tutorial, announcement, report

        var title: String {
            switch self {
            case .tutorial: return "Tutorial"
            case .announcement: return "Announcement"
            case .report: return "How to report calls"
            }
        }
    }

    let kind: Kind

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PageHeader(eyebrow: "Discover", title: kind.title, subtitle: subtitle)
                Card {
                    switch kind {
                    case .tutorial:
                        Text("1. Enable Caller ID in iPhone Settings > Phone > Call Blocking & Identification.")
                        Text("2. Import a number database from Menu so Callora can identify calls.").padding(.top, 12)
                        Text("3. Search unknown numbers using the Home search box.").padding(.top, 12)
                    case .announcement:
                        Text("Welcome to Callora. Identify numbers, block spam from your local database, and manage unwanted callers.")
                    case .report:
                        Text("Call reporting is not available yet. Search the number in Home and choose Block this number, or add it through Protection > Block list.")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color.ink)
            }
            .padding(20)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle(kind.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var subtitle: String {
        switch kind {
        case .tutorial: return "Get started with Callora"
        case .announcement: return "The latest news from Callora"
        case .report: return "How to handle suspicious calls"
        }
    }
}

struct SearchView: View {
    @EnvironmentObject private var store: DirectoryStore
    @State private var query = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                PageHeader(eyebrow: "Number search", title: "Who is calling?", subtitle: "Find a number identity from the database stored on your device.")

                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass").font(.title3.weight(.semibold)).foregroundStyle(Color.brand)
                    TextField("Contoh: +628123456789", text: $query)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                        .autocorrectionDisabled()
                        .foregroundStyle(Color.ink)
                        .accessibilityLabel("Number with country code")
                    if !query.isEmpty {
                        Button { query = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(Color.muted)
                        }
                        .accessibilityLabel("Clear search")
                    }
                }
                .padding(18)
                .background(.white, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.line, lineWidth: 1))

                if query.isEmpty {
                    Card {
                        IconTile(symbol: "globe.asia.australia.fill", size: 54)
                        Text("Start with a complete number")
                            .font(.headline).foregroundStyle(Color.ink).padding(.top, 17)
                        Text("Use + and a country code. Search results are available for numbers you have imported.")
                            .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } else if let number = PhoneNumber.normalize(query) {
                    result(for: number)
                } else {
                    Card {
                        StatusPill(title: "Invalid format", symbol: "info.circle.fill", color: .danger)
                        Text("Enter +, a country code, and the number without a leading 0 after the country code.")
                            .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 12)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle("Search numbers")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func result(for number: String) -> some View {
        let entry = store.lookup(number)
        let spam = entry?.isSpam == true
        let blocked = store.isBlocked(number)
        return VStack(alignment: .leading, spacing: 16) {
            Text("HASIL PENCARIAN")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(2).foregroundStyle(Color.muted)
            Card {
                HStack(alignment: .top, spacing: 15) {
                    IconTile(symbol: spam ? "exclamationmark.triangle.fill" : "person.crop.circle.fill", color: spam ? .danger : .brand, size: 58)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(entry?.name ?? "Unknown number")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.ink)
                        Text(number).font(.subheadline).foregroundStyle(Color.muted)
                    }
                }
                .padding(.bottom, 18)
                StatusPill(title: spam ? "Potential spam" : entry == nil ? "No data" : "Known", symbol: spam ? "exclamationmark.shield.fill" : entry == nil ? "questionmark.circle.fill" : "checkmark.seal.fill", color: spam ? .danger : .brand)
                if let entry {
                    Rectangle().fill(Color.line).frame(height: 1).padding(.vertical, 16)
                    HStack {
                        info(label: "Kategori", value: entry.category)
                        Spacer()
                        info(label: "Laporan", value: "\(entry.reports)")
                    }
                } else {
                    Text("This number is not in your local database.")
                        .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 14)
                }
            }
            if blocked {
                StatusPill(title: "This number is blocked", symbol: "hand.raised.fill")
            } else {
                FilledAction(title: "Block this number", symbol: "hand.raised.fill") {
                    _ = store.addBlock(number)
                }
            }
        }
    }

    private func info(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundStyle(Color.muted)
            Text(value).font(.subheadline.weight(.semibold)).foregroundStyle(Color.ink)
        }
    }
}
