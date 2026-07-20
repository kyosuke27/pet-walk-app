/// アプリ設定を表すエンティティ。
struct AppSettings: Equatable {
    /// 通知設定が有効かどうか。
    var notificationsEnabled: Bool
    /// 距離表示単位。
    var distanceUnit: DistanceUnit
    /// 広告削除が購入済みかどうか。
    var hasRemovedAds: Bool
}
