import Foundation

/// 散歩記録に保存する目的地情報。
struct WalkDestination: Identifiable, Equatable {
    /// 目的地情報の識別子。
    let id: UUID
    /// 元になった候補スポットの識別子。
    let spotId: UUID?
    /// 目的地名。
    let name: String
    /// 目的地カテゴリ。
    let category: String
    /// 緯度。
    let latitude: Double
    /// 経度。
    let longitude: Double
    /// 目的地までの推定距離。
    let estimatedDistanceMeters: Double?
}
