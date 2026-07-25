import SwiftUI

/// Settings画面の依存解決と状態接続を行うContainer。
struct SettingsContainer: View {
    /// Settings画面の状態管理。
    @StateObject private var viewModel: SettingsScreenViewModel

    /// Containerを生成する。
    /// - Parameter viewModel: DIされたSettings画面ViewModel。
    init(viewModel: SettingsScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        SettingsScreen(
            state: viewModel.state,
            onEvent: viewModel.onEvent
        )
    }
}
