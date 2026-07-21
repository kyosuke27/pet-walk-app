/// アプリ設定の保存と取得を担うRepositoryインターフェース。
protocol SettingsRepository {
    /// 現在のアプリ設定を取得する。
    /// - Returns: 保存済みのアプリ設定。
    func fetchSettings() -> AppSettings

    /// アプリ設定を保存する。
    /// - Parameter settings: 保存するアプリ設定。
    func saveSettings(_ settings: AppSettings)
}
