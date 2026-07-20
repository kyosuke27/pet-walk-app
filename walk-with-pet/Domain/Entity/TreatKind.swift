import SwiftUI

/// おやつの種類を表す列挙型。
enum TreatKind: String, CaseIterable, Identifiable {
    /// 一覧表示で使用する識別子。
    var id: String { rawValue }

    case smallSnack
    case freshFruit
    case specialMeal
    case rareTreat

    /// 画面表示用のローカライズキー。
    var titleKey: LocalizedStringKey {
        switch self {
        case .smallSnack:
            return "treat.smallSnack"
        case .freshFruit:
            return "treat.freshFruit"
        case .specialMeal:
            return "treat.specialMeal"
        case .rareTreat:
            return "treat.rareTreat"
        }
    }

    /// おやつアイコンとして使うSF Symbols名。
    var symbolName: String {
        switch self {
        case .smallSnack:
            return "takeoutbag.and.cup.and.straw.fill"
        case .freshFruit:
            return "leaf.fill"
        case .specialMeal:
            return "fork.knife.circle.fill"
        case .rareTreat:
            return "star.fill"
        }
    }

    /// おやつ種別ごとのアクセントカラー。
    var accentColor: Color {
        switch self {
        case .smallSnack:
            return AppColor.treatGold
        case .freshFruit:
            return AppColor.trailGreen
        case .specialMeal:
            return AppColor.treatOrange
        case .rareTreat:
            return AppColor.treatPurple
        }
    }
}
