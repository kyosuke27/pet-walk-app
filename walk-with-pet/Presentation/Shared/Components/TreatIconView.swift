import SwiftUI

/// おやつ種別を表示するアイコンView。
struct TreatIconView: View {
    /// 表示するおやつ種別。
    let kind: TreatKind
    /// アイコンサイズ。
    var size: CGFloat = 58

    var body: some View {
        Image(systemName: kind.symbolName)
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(kind.accentColor)
            .frame(width: size, height: size)
            .background(kind.accentColor.opacity(0.16))
            .clipShape(Circle())
    }
}
