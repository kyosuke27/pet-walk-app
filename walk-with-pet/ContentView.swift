//
//  ContentView.swift
//  walk-with-pet
//
//  Created by kyosuke on 2026/07/19.
//

import SwiftUI

/// アプリ起動直後に表示するルートView。
struct ContentView: View {
    /// アプリ全体の画面遷移状態。
    @StateObject private var router = Router()

    var body: some View {
        NavigationStack(path: routePathBinding) {
            TabView(selection: selectedTabBinding) {
                HomeContainer(viewModel: HomeScreenViewModel(router: router))
                    .tabItem {
                        Label(AppTab.home.titleKey, systemImage: router.selectedTab == .home ? AppTab.home.selectedSymbolName : AppTab.home.symbolName)
                    }
                    .tag(AppTab.home)

                HistoryContainer(viewModel: HistoryScreenViewModel(router: router))
                    .tabItem {
                        Label(AppTab.history.titleKey, systemImage: router.selectedTab == .history ? AppTab.history.selectedSymbolName : AppTab.history.symbolName)
                    }
                    .tag(AppTab.history)

                SettingsContainer(viewModel: SettingsScreenViewModel(router: router))
                    .tabItem {
                        Label(AppTab.settings.titleKey, systemImage: router.selectedTab == .settings ? AppTab.settings.selectedSymbolName : AppTab.settings.symbolName)
                    }
                    .tag(AppTab.settings)
            }
            .tint(AppColor.trailGreen)
            .navigationDestination(for: AppRoute.self) { route in
                routeDestination(route)
            }
        }
    }

    /// TabViewとRouterを接続するBinding。
    private var selectedTabBinding: Binding<AppTab> {
        Binding(
            get: { router.selectedTab },
            set: { router.selectTab($0) }
        )
    }

    /// NavigationStackとRouterを接続するBinding。
    private var routePathBinding: Binding<[AppRoute]> {
        Binding(
            get: { router.path },
            set: { router.replacePath($0) }
        )
    }

    /// Routeに対応する画面を生成する。
    /// - Parameter route: 表示するRoute。
    /// - Returns: Routeに対応するView。
    @ViewBuilder
    private func routeDestination(_ route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeContainer(viewModel: HomeScreenViewModel(router: router))
        case .history:
            HistoryContainer(viewModel: HistoryScreenViewModel(router: router))
        case .settings:
            SettingsContainer(viewModel: SettingsScreenViewModel(router: router))
        case .walkSpots:
            RoutePlaceholderScreen(titleKey: "route.walkSpots")
        case .activeWalk:
            RoutePlaceholderScreen(titleKey: "route.activeWalk")
        case .walkResult:
            RoutePlaceholderScreen(titleKey: "route.walkResult")
        }
    }
}
