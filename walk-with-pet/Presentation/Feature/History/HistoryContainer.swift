import SwiftUI

/// History画面の依存解決と状態接続を行うContainer。
struct HistoryContainer: View {
    /// History画面の状態管理。
    @StateObject private var viewModel: HistoryScreenViewModel

    /// Containerを生成する。
    /// - Parameter viewModel: DIされたHistory画面ViewModel。
    init(viewModel: HistoryScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        HistoryScreen(
            state: viewModel.state,
            onEvent: viewModel.onEvent
        )
    }
}
