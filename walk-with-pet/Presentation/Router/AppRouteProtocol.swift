/// 画面遷移操作を抽象化するProtocol。
protocol AppRouteProtocol: AnyObject {
    /// 現在選択中のタブ。
    var selectedTab: AppTab { get }
    /// 現在表示中のRoute。
    var currentRoute: AppRoute { get }
    /// 画面遷移スタック。
    var path: [AppRoute] { get }

    /// 指定したタブへ切り替える。
    /// - Parameter tab: 選択するタブ。
    func selectTab(_ tab: AppTab)

    /// 次の画面へ遷移する。
    /// - Parameter route: 遷移先Route。
    func push(_ route: AppRoute)

    /// 画面遷移スタックを置き換える。
    /// - Parameter path: 新しい画面遷移スタック。
    func replacePath(_ path: [AppRoute])

    /// 前の画面へ戻る。
    func pop()

    /// 現在タブのルート画面へ戻る。
    func popToRoot()
}
