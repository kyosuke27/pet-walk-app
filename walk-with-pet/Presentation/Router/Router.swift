import Combine
import Foundation

/// アプリ全体の画面遷移状態を管理するRouter。
final class Router: ObservableObject, AppRouteProtocol {
    /// 現在選択中のタブ。
    @Published private(set) var selectedTab: AppTab
    /// 画面遷移スタック。
    @Published private(set) var path: [AppRoute]

    /// 現在表示中のRoute。
    var currentRoute: AppRoute {
        path.last ?? selectedTab.route
    }

    /// Routerを初期化する。
    /// - Parameters:
    ///   - selectedTab: 初期選択タブ。
    ///   - path: 初期遷移スタック。
    init(selectedTab: AppTab = .home, path: [AppRoute] = []) {
        self.selectedTab = selectedTab
        self.path = path
    }

    /// 指定したタブへ切り替える。
    /// - Parameter tab: 選択するタブ。
    func selectTab(_ tab: AppTab) {
        selectedTab = tab
        path.removeAll()
    }

    /// 次の画面へ遷移する。
    /// - Parameter route: 遷移先Route。
    func push(_ route: AppRoute) {
        path.append(route)
    }

    /// 画面遷移スタックを置き換える。
    /// - Parameter path: 新しい画面遷移スタック。
    func replacePath(_ path: [AppRoute]) {
        self.path = path
    }

    /// 前の画面へ戻る。
    func pop() {
        guard !path.isEmpty else {
            return
        }
        path.removeLast()
    }

    /// 現在タブのルート画面へ戻る。
    func popToRoot() {
        path.removeAll()
    }
}
