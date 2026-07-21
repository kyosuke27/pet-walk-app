import Foundation

/// アプリ全体の画面遷移先を表す列挙型。
enum AppRoute: Hashable {
    /// ホーム画面。
    case home
    /// 履歴画面。
    case history
    /// 設定画面。
    case settings
    /// 目的地選択画面。
    case walkSpots
    /// 散歩中画面。
    case activeWalk
    /// 散歩結果画面。
    case walkResult
}

extension AppTab {
    /// タブに対応するRoute。
    var route: AppRoute {
        switch self {
        case .home:
            return .home
        case .history:
            return .history
        case .settings:
            return .settings
        }
    }
}
