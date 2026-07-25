import SwiftUI

/// 補助操作に使用するボタン。
struct SecondaryButton: View {
    /// ボタン文言のローカライズキー。
    let titleKey: LocalizedStringKey
    /// SF Symbols名。
    let systemImage: String
    /// 強調色。
    var tint: Color = AppColor.trailGreen
    /// タップ時の処理。
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(titleKey, systemImage: systemImage)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .buttonStyle(.plain)
        .foregroundStyle(tint)
        .background(AppColor.softWhite)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(tint.opacity(0.18), lineWidth: 1)
        }
    }
}
