import Foundation

/// 画面表示用の値変換をまとめる型。
enum AppFormatters {
    /// 距離を指定単位の文字列へ変換する。
    /// - Parameters:
    ///   - meters: メートル単位の距離。
    ///   - unit: 表示単位。
    /// - Returns: 画面表示用の距離文字列。
    static func distanceText(meters: Double, unit: DistanceUnit = .kilometers) -> String {
        switch unit {
        case .kilometers:
            return String(format: "%.1f km", meters / 1000)

        case .miles:
            return String(format: "%.1f miles", meters / 1609.344)
        }
    }

    /// 秒数を分秒の文字列へ変換する。
    /// - Parameter seconds: 秒数。
    /// - Returns: `mm:ss` 形式の文字列。
    static func durationText(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    /// 日付を短い履歴表示へ変換する。
    /// - Parameter date: 表示対象の日付。
    /// - Returns: 例 `May 15, 2025` の文字列。
    static func historyDateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    /// 履歴行の日付上段に表示する曜日へ変換する。
    /// - Parameter date: 表示対象の日付。
    /// - Returns: 現在のロケールに合わせた曜日文字列。
    static func historyWeekdayText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    /// 履歴行の日付下段に表示する年月日へ変換する。
    /// - Parameter date: 表示対象の日付。
    /// - Returns: `yyyy/MM/dd` 形式の日付文字列。
    static func historyNumericDateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}
