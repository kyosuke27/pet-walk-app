import SwiftUI

/// 主要操作に使用するボタン。
struct PrimaryButton: View {
    /// ボタン文言のローカライズキー。
    let titleKey: LocalizedStringKey
    /// SF Symbols名。
    let systemImage: String
    /// タップ時の処理。
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(titleKey, systemImage: systemImage)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .padding(.horizontal, 14)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(AppColor.trailGreen)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
