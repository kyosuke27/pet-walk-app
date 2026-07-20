import SwiftUI

/// PawTrail全体で使用する文字スタイル定義。
enum AppTypography {
    /// 大見出し。
    static let screenTitle = Font.system(size: 44, weight: .bold, design: .rounded)
    /// カード見出し。
    static let cardTitle = Font.system(size: 22, weight: .bold, design: .rounded)
    /// 大きな数値。
    static let metric = Font.system(size: 72, weight: .bold, design: .rounded)
    /// 本文。
    static let body = Font.system(size: 17, weight: .regular, design: .rounded)
    /// 補助テキスト。
    static let caption = Font.system(size: 13, weight: .medium, design: .rounded)
}
