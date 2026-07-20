import Foundation

/// 所持しているおやつを表すエンティティ。
struct Treat: Identifiable, Equatable {
    /// おやつの識別子。
    let id: UUID
    /// おやつの種類。
    let kind: TreatKind
    /// Feed時のBuddy Energy回復量。
    let energyValue: Int
    /// 現在の所持数。
    var ownedCount: Int
}
