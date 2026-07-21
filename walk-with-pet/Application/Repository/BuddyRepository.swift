/// 相棒状態の保存と取得を担うRepositoryインターフェース。
protocol BuddyRepository {
    /// 現在の相棒状態を取得する。
    /// - Returns: 保存済みの相棒状態。
    func fetchBuddy() async throws -> Buddy

    /// 相棒状態を保存する。
    /// - Parameter buddy: 保存する相棒状態。
    func saveBuddy(_ buddy: Buddy) async throws
}
