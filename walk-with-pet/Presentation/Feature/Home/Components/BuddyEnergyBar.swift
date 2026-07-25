import SwiftUI

/// 相棒の元気を太めのバーで表示するView。
struct BuddyEnergyBar: View {
    /// 元気の割合。
    let value: Int

    var body: some View {
        GeometryReader { proxy in
            let progress = min(max(CGFloat(value) / 100, 0), 1)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppColor.softMint.opacity(0.75))
                Capsule()
                    .fill(AppColor.trailGreen)
                    .frame(width: proxy.size.width * progress)
            }
        }
        .frame(height: 14)
    }
}
