import Foundation

/// ユーザーの相棒状態を表すエンティティ。
struct Buddy: Identifiable, Equatable {
    /// 相棒の識別子。
    let id: UUID
    /// 相棒の表示名。
    var name: String
    /// 相棒の元気値。0から100で扱う。
    var energy: Int
    /// 最後におやつをあげた日時。
    var lastFedAt: Date?
    /// 元気値から導かれる現在の状態文言。
    var mood: BuddyMood {
        if energy >= 70 {
            return .good
        }
        if energy >= 40 {
            return .needsWalk
        }
        return .needsCare
    }
}

/// 相棒の状態文言を切り替えるための列挙型。
enum BuddyMood {
    case good
    case needsWalk
    case needsCare

    /// 画面表示用のローカライズキー。
    var titleKey: String {
        switch self {
        case .good:
            return "buddy.mood.good"
        case .needsWalk:
            return "buddy.mood.needsWalk"
        case .needsCare:
            return "buddy.mood.needsCare"
        }
    }
}
