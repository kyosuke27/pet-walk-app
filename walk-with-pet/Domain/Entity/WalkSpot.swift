import Foundation

/// 散歩前に提示する目的地候補を表すエンティティ。
struct WalkSpot: Identifiable, Equatable {
    /// 目的地候補の識別子。
    let id: UUID
    /// スポット名。
    let name: String
    /// スポットカテゴリ。
    let category: String
    /// 現在地からの推定距離。
    let distanceMeters: Double
    /// 緯度。
    let latitude: Double
    /// 経度。
    let longitude: Double
}

extension WalkSpot {
    /// 散歩記録用の目的地情報へ変換する。
    /// - Returns: 履歴に保存する目的地情報。
    func toWalkDestination() -> WalkDestination {
        WalkDestination(
            id: UUID(),
            spotId: id,
            name: name,
            category: category,
            latitude: latitude,
            longitude: longitude,
            estimatedDistanceMeters: distanceMeters
        )
    }
}
