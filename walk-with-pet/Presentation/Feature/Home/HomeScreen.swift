import SwiftUI

/// 今日の距離、相棒状態、おやつ在庫を表示するHome画面。
struct HomeScreen: View {
    /// Home画面の表示状態。
    let state: HomeState
    /// Home画面のイベント通知先。
    let onEvent: (HomeEvent) -> Void

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    headerView
                    distanceCard
                    buddyCard
                    treatsCard
                    actionButtons
                    adPlaceholder
                }
                .padding(.horizontal, AppSpacing.screen)
                .padding(.top, 24)
                .padding(.bottom, 28)
            }
            .background(AppColor.warmIvory.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    /// 画面上部のタイトル領域。
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("home.greeting")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.mistGray)
                Text("home.title")
                    .font(AppTypography.screenTitle)
                    .foregroundStyle(AppColor.deepForest)
            }
        }
    }

    /// 今日の距離カード。
    private var distanceCard: some View {
        AppCard {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("home.distanceToday")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColor.trailGreen)
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(String(format: "%.1f", state.todayDistanceMeters / 1000))
                            .font(AppTypography.metric)
                            .foregroundStyle(AppColor.deepForest)
                        Text("km")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColor.deepForest)
                    }
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(AppColor.softMint, lineWidth: 10)
                        .frame(width: 108, height: 108)
                    Circle()
                        .trim(from: 0, to: min(state.todayDistanceMeters / state.goalDistanceMeters, 1))
                        .stroke(AppColor.trailGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 108, height: 108)
                    Image(systemName: "figure.walk")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(AppColor.trailGreen)
                }
            }
        }
    }

    /// 相棒状態カード。
    private var buddyCard: some View {
        AppCard {
            HStack(spacing: 18) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(AppColor.softMint.opacity(0.55))
                        .frame(width: 126, height: 126)
                    Image(systemName: "dog.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(AppColor.mistGray.opacity(0.8))
                    TreatIconView(kind: .freshFruit, size: 34)
                        .offset(x: 8, y: -8)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("home.buddy")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColor.deepForest)
                    Text(LocalizedStringKey(state.buddy.mood.titleKey))
                        .font(AppTypography.body)
                        .foregroundStyle(AppColor.trailGreen)
                    HStack {
                        Text("home.buddyEnergy")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColor.deepForest)
                        Spacer()
                        Text("\(state.buddy.energy)%")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColor.trailGreen)
                    }
                    ProgressView(value: Double(state.buddy.energy), total: 100)
                        .tint(AppColor.trailGreen)
                }
            }
        }
    }

    /// 横スクロールのおやつ一覧カード。
    private var treatsCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("home.treats", systemImage: "gift")
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColor.deepForest)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(state.treats) { treat in
                            VStack(spacing: 8) {
                                TreatIconView(kind: treat.kind)
                                Text(treat.kind.titleKey)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(AppColor.deepForest)
                                    .frame(width: 96)
                                Text("\(treat.ownedCount)")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .foregroundStyle(AppColor.trailGreen)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 5)
                                    .background(AppColor.softMint.opacity(0.7))
                                    .clipShape(Capsule())
                            }
                            .frame(width: 104)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    /// 主要操作ボタン。
    private var actionButtons: some View {
        HStack(spacing: 14) {
            PrimaryButton(titleKey: "home.startWalk", systemImage: "figure.walk") {
                onEvent(.startWalkTapped)
            }
            SecondaryButton(titleKey: "home.feed", systemImage: "heart.fill", tint: AppColor.treatOrange) {
                onEvent(.feedTapped)
            }
        }
    }

    /// Phase 0用の広告プレースホルダー。
    private var adPlaceholder: some View {
        AppCard {
            HStack(spacing: 14) {
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundStyle(AppColor.mistGray.opacity(0.7))
                    .frame(width: 54, height: 44)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.mistGray.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [4]))
                    }
                VStack(alignment: .leading, spacing: 4) {
                    Text("home.premium")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColor.deepForest)
                    Text("home.premium.description")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColor.mistGray)
                }
                Spacer()
                Text("Ad")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.mistGray)
            }
        }
    }
}
