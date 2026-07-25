import SwiftUI

/// 丸い背景を持つアイコンボタン。
struct AppIconButton: View {
    /// SF Symbols名。
    let systemImage: String
    /// アクセシビリティ用の説明。
    let accessibilityLabelKey: LocalizedStringKey
    /// タップ時の処理。
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .semibold))
                .frame(width: 56, height: 56)
                .background(AppColor.softMint.opacity(0.75))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(AppColor.trailGreen)
        .accessibilityLabel(accessibilityLabelKey)
    }
}
