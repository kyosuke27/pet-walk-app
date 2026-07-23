import SwiftUI

/// Home画面の依存解決と状態接続を行うContainer。
struct HomeContainer: View {
    /// Home画面の状態管理。
    @StateObject private var viewModel: HomeScreenViewModel

    /// Containerを生成する。
    /// - Parameter viewModel: DIされたHome画面ViewModel。
    init(viewModel: HomeScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        HomeScreen(
            state: viewModel.state,
            onEvent: viewModel.onEvent
        )
    }
}
