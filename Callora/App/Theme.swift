import SwiftUI

extension Color {
    static let brand = Color(red: 0.10, green: 0.48, blue: 0.95)
    static let brandLight = Color(red: 0.88, green: 0.95, blue: 1.0)
    static let canvas = Color(red: 0.94, green: 0.98, blue: 1.0)
    static let ink = Color(red: 0.05, green: 0.16, blue: 0.30)
    static let muted = Color(red: 0.35, green: 0.48, blue: 0.62)
    static let line = Color(red: 0.84, green: 0.92, blue: 0.99)
    static let danger = Color(red: 0.84, green: 0.25, blue: 0.30)
}

struct Card<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(Color.line.opacity(0.7), lineWidth: 1)
            }
    }
}

struct SectionHeading: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 21, weight: .bold, design: .rounded)).foregroundStyle(Color.ink)
            Text(subtitle).font(.subheadline).foregroundStyle(Color.muted)
        }
    }
}

struct IconTile: View {
    let symbol: String
    var color: Color = .brand
    var size: CGFloat = 48

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size * 0.40, weight: .semibold))
            .foregroundStyle(color)
            .frame(width: size, height: size)
            .background(color.opacity(0.09), in: RoundedRectangle(cornerRadius: size * 0.31, style: .continuous))
    }
}

struct StatusPill: View {
    let title: String
    let symbol: String
    var color: Color = .brand

    var body: some View {
        Label(title, systemImage: symbol)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 11)
            .padding(.vertical, 7)
            .background(color.opacity(0.09), in: Capsule())
    }
}

struct PageHeader: View {
    let eyebrow: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(eyebrow.uppercased())
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .tracking(2)
                .foregroundStyle(Color.brand)
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.ink)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(Color.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 12)
    }
}

struct FilledAction: View {
    let title: String
    let symbol: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: symbol)
            }
            .font(.subheadline.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 52)
            .background(Color.brand, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
