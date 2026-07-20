import Foundation

/// 完了した散歩記録を表すエンティティ。
struct WalkRecord: Identifiable, Equatable {
    /// 散歩記録の識別子。
    let id: UUID
    /// 散歩開始日時。
    let startedAt: Date
    /// 散歩終了日時。
    let endedAt: Date
    /// 記録した距離。
    let distanceMeters: Double
    /// 散歩時間。
    let durationSeconds: Int
    /// 獲得したおやつ。
    let earnedTreatKind: TreatKind?
    /// Feed時に見込まれるBuddy Energy回復量。
    let energyGain: Int
    /// 散歩で選択した目的地情報。
    let destination: WalkDestination?
}
