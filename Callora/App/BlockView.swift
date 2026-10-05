import SwiftUI
import UIKit

struct ProtectionView: View {
    @EnvironmentObject private var store: DirectoryStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                PageHeader(eyebrow: "Protection", title: "Spam protection", subtitle: "Set up call protection for your needs.")

                Card {
                    HStack(spacing: 14) {
                        IconTile(symbol: store.extensionEnabled ? "checkmark.shield.fill" : "shield.slash.fill", size: 54)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(store.extensionEnabled ? "Caller ID enabled" : "Caller ID disabled")
                                .font(.headline).foregroundStyle(Color.ink)
                            Text(store.extensionEnabled ? "Callora is ready to identify numbers." : "Enable Callora in iPhone Settings.")
                                .font(.subheadline).foregroundStyle(Color.muted)
                        }
                    }
                    FilledAction(title: "Open Caller ID settings", symbol: "arrow.up.right") {
                        if let url = URL(string: UIApplication.openSettingsURLString) { UIApplication.shared.open(url) }
                    }
                    .padding(.top, 18)
                    Text("In Settings, open Phone > Call Blocking & Identification, then enable Callora.")
                        .font(.caption).foregroundStyle(Color.muted).padding(.top, 10)
                }

                NavigationLink { FamilyGroupView() } label: {
                    menuRow("Family group", subtitle: "Protection for your family", symbol: "person.2.fill")
                }
                .buttonStyle(.plain)

                Card {
                    HStack(spacing: 14) {
                        IconTile(symbol: "hand.raised.fill")
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Auto-block spam").font(.subheadline.weight(.bold)).foregroundStyle(Color.ink)
                            Text(store.snapshot.automaticBlocking ? "Enabled" : "Disabled")
                                .font(.caption).foregroundStyle(Color.muted)
                        }
                        Spacer(minLength: 4)
                        Toggle("Auto-block spam", isOn: Binding(get: { store.snapshot.automaticBlocking }, set: { store.setAutomaticBlocking($0) }))
                            .labelsHidden()
                            .tint(.brand)
                    }
                    Text("Automatically block numbers marked as spam in your local database.")
                        .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 14)
                }

                NavigationLink { NumberSeriesView() } label: {
                    menuRow("Number series", subtitle: "Add a number prefix", symbol: "number")
                }
                .buttonStyle(.plain)

                NavigationLink { BlockListView() } label: {
                    menuRow("Block list", subtitle: "Manage blocked numbers", symbol: "phone.down.fill")
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(Color.canvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { store.refreshStatus() }
    }

    private func menuRow(_ title: String, subtitle: String, symbol: String) -> some View {
        HStack(spacing: 14) {
            IconTile(symbol: symbol)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.bold)).foregroundStyle(Color.ink)
                Text(subtitle).font(.caption).foregroundStyle(Color.muted)
            }
            Spacer(minLength: 4)
            Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(Color.muted)
        }
        .padding(20)
        .background(.white, in: RoundedRectangle(cornerRadius: 24))
    }
}

struct FamilyGroupView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PageHeader(eyebrow: "Protection", title: "Family group", subtitle: "Protect the people closest to you with Callora.")
                Card {
                    IconTile(symbol: "person.2.fill", size: 54)
                    Text("Family group is coming soon")
                        .font(.headline).foregroundStyle(Color.ink).padding(.top, 16)
                    Text("Sharing protection with family members is not available yet.")
                        .font(.subheadline).foregroundStyle(Color.muted).padding(.top, 6)
                }
            }
            .padding(20)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle("Family group")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NumberSeriesView: View {
    @EnvironmentObject private var store: DirectoryStore
    @State private var prefix = ""
    @State private var invalidPrefix = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PageHeader(eyebrow: "Protection", title: "Number series", subtitle: "Block local database numbers that start with a specific prefix.")
                Card {
                    HStack(spacing: 12) {
                        Image(systemName: "number").foregroundStyle(Color.brand)
                        TextField("Contoh: +62877", text: $prefix)
                            .keyboardType(.phonePad)
                            .accessibilityLabel("Prefix to block")
                        Button {
                            invalidPrefix = !store.addPrefix(prefix)
                            if !invalidPrefix { prefix = "" }
                        } label: {
                            Image(systemName: "plus")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.brand, in: RoundedRectangle(cornerRadius: 11))
                        }
                        .accessibilityLabel("Add prefix")
                    }
                    if invalidPrefix {
                        Text("Enter a prefix with a country code and at least two digits.")
                            .font(.caption).foregroundStyle(Color.danger).padding(.top, 10)
                    }
                }
                if store.snapshot.blockedPrefixes.isEmpty {
                    Text("No prefixes added yet.")
                        .font(.subheadline).foregroundStyle(Color.muted)
                } else {
                    Card {
                        ForEach(store.snapshot.blockedPrefixes, id: \.self) { entry in
                            HStack(spacing: 12) {
                                IconTile(symbol: "number", size: 38)
                                Text("\(entry)…").font(.subheadline.weight(.medium)).foregroundStyle(Color.ink)
                                Spacer()
                                Button { store.removePrefix(entry) } label: {
                                    Image(systemName: "minus.circle.fill").font(.title3).foregroundStyle(Color.muted)
                                }
                                    .accessibilityLabel("Remove prefix \(entry)")
                            }
                            .padding(.vertical, 7)
                        }
                    }
                }
                Text("iOS can only block complete numbers already in the local database that match this prefix.")
                    .font(.caption).foregroundStyle(Color.muted)
            }
            .padding(20)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle("Number series")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BlockListView: View {
    @EnvironmentObject private var store: DirectoryStore
    @State private var number = ""
    @State private var invalidNumber = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PageHeader(eyebrow: "Protection", title: "Block list", subtitle: "Manage numbers you do not want to contact you.")
                Card {
                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill").foregroundStyle(Color.brand)
                        TextField("Contoh: +628123456789", text: $number)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                            .accessibilityLabel("Number to block")
                        Button {
                            invalidNumber = !store.addBlock(number)
                            if !invalidNumber { number = "" }
                        } label: {
                            Image(systemName: "plus")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.brand, in: RoundedRectangle(cornerRadius: 11))
                        }
                        .accessibilityLabel("Add number")
                    }
                    if invalidNumber {
                        Text("Enter a valid international number.")
                            .font(.caption).foregroundStyle(Color.danger).padding(.top, 10)
                    }
                }
                if store.snapshot.manualBlocks.isEmpty {
                    Text("No numbers in the block list yet.")
                        .font(.subheadline).foregroundStyle(Color.muted)
                } else {
                    Card {
                        ForEach(store.snapshot.manualBlocks, id: \.self) { entry in
                            HStack(spacing: 12) {
                                IconTile(symbol: "phone.down.fill", size: 38)
                                Text(entry).font(.subheadline.weight(.medium)).foregroundStyle(Color.ink)
                                Spacer()
                                Button { store.removeBlock(entry) } label: {
                                    Image(systemName: "minus.circle.fill").font(.title3).foregroundStyle(Color.muted)
                                }
                                    .accessibilityLabel("Remove \(entry) from block list")
                            }
                            .padding(.vertical, 7)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(Color.canvas.ignoresSafeArea())
        .navigationTitle("Block list")
        .navigationBarTitleDisplayMode(.inline)
    }
}
