import Foundation

/// 距離単位の画面表示用拡張。
extension DistanceUnit: CaseIterable, Identifiable {
    /// 設定画面で選択可能な距離単位。
    static var allCases: [DistanceUnit] {
        [.kilometers, .miles]
    }

    /// 一覧表示で使用する識別子。
    var id: String { rawValue }

    /// UI表示用の短い単位名。
    var label: String {
        switch self {
        case .kilometers:
            return "km"

        case .miles:
            return "miles"
        }
    }
}
