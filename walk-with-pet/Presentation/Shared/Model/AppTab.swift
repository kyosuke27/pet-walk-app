import SwiftUI

/// メインタブを表す列挙型。
enum AppTab: Hashable {
    case home
    case history
    case settings

    /// タブタイトルのローカライズキー。
    var titleKey: LocalizedStringKey {
        switch self {
        case .home:
            return "tab.home"
        case .history:
            return "tab.history"
        case .settings:
            return "tab.settings"
        }
    }

    /// 通常状態のSF Symbols名。
    var symbolName: String {
        switch self {
        case .home:
            return "house"
        case .history:
            return "calendar"
        case .settings:
            return "gearshape"
        }
    }

    /// 選択状態のSF Symbols名。
    var selectedSymbolName: String {
        switch self {
        case .home:
            return "house.fill"
        case .history:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}
