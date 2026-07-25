import SwiftUI

/// PawTrailのカードUIを統一するコンテナ。
struct AppCard<Content: View>: View {
    /// カード内に表示する内容。
    private let content: Content

    /// カードを生成する。
    /// - Parameter content: カード内に表示するView。
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppSpacing.card)
            .background(AppColor.softWhite)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(AppColor.softMint.opacity(0.7), lineWidth: 1)
            }
            .shadow(color: AppColor.deepForest.opacity(0.08), radius: 14, x: 0, y: 8)
    }
}
