/// 散歩記録の保存と取得を担うRepositoryインターフェース。
protocol WalkRepository {
    /// 保存済みの散歩履歴を取得する。
    /// - Returns: 散歩記録一覧。
    func fetchWalkRecords() async throws -> [WalkRecord]

    /// 散歩記録を保存する。
    /// - Parameter record: 保存する散歩記録。
    func saveWalkRecord(_ record: WalkRecord) async throws
}
