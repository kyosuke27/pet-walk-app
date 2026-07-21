/// 散歩目的地候補の取得を担うRepositoryインターフェース。
protocol SpotRepository {
    /// 現在地周辺の目的地候補を取得する。
    /// - Parameters:
    ///   - latitude: 現在地の緯度。
    ///   - longitude: 現在地の経度。
    ///   - radiusMeters: 検索半径。
    /// - Returns: 目的地候補一覧。
    func fetchNearbySpots(latitude: Double, longitude: Double, radiusMeters: Double) async throws -> [WalkSpot]
}
