import SwiftUI

/// 今日の距離、相棒状態、おやつ在庫を表示するHome画面。
struct HomeScreen: View {
    /// Home画面の表示状態。
    let state: HomeState
    /// Home画面のイベント通知先。
    let onEvent: (HomeEvent) -> Void

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let verticalSpacing = 12.0
                let topPadding = 14.0
                let bottomContentPadding = proxy.safeAreaInsets.bottom + AppSpacing.medium
                let headerHeight = 38.0
                let sectionHeights = sectionHeights(
                    screenHeight: proxy.size.height,
                    headerHeight: headerHeight,
                    topPadding: topPadding,
                    bottomPadding: bottomContentPadding,
                    verticalSpacing: verticalSpacing
                )

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        headerView
                            .frame(height: headerHeight, alignment: .topLeading)
                        distanceCard
                            .frame(height: sectionHeights.distance)
                        buddyCard
                            .frame(height: sectionHeights.buddy)
                        treatsCard
                            .frame(height: sectionHeights.treats)
                        actionButtons
                            .frame(height: sectionHeights.buttons)
                        if state.showsAdPlaceholder {
                            adPlaceholder
                                .frame(height: sectionHeights.ad)
                        }
                    }
                    .padding(.horizontal, AppSpacing.screen)
                    .padding(.top, topPadding)
                    // タブバーやホームインジケータの実際のsafe areaに合わせて下側の余白を確保する。
                    .padding(.bottom, bottomContentPadding)
                    // 画面高さを下回る場合は上寄せを維持し、超える場合は縦スクロールで見切れを防ぐ。
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height, alignment: .top)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColor.warmIvory.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    /// 画面上部のタイトル領域。
    private var headerView: some View {
        HStack(alignment: .top) {
            Text("home.title")
                .font(AppTypography.screenTitle)
                .foregroundStyle(AppColor.deepForest)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
    }

    /// 今日の距離カード。
    private var distanceCard: some View {
        AppCard {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("home.distanceToday")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColor.trailGreen)
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(String(format: "%.1f", state.todayDistanceMeters / 1000))
                            .font(.system(size: 104, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColor.deepForest)
                        Text("km")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColor.deepForest)
                    }
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(AppColor.softMint, lineWidth: 10)
                        .frame(width: 76, height: 76)
                    Circle()
                        .trim(from: 0, to: min(state.todayDistanceMeters / state.goalDistanceMeters, 1))
                        .stroke(AppColor.trailGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 76, height: 76)
                    Image(systemName: "figure.walk")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(AppColor.trailGreen)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    /// 相棒状態カード。
    private var buddyCard: some View {
        AppCard {
            HStack(spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(AppColor.softMint.opacity(0.55))
                        .frame(width: 82, height: 82)
                    Image(systemName: "dog.fill")
                        .font(.system(size: 42))
                        .foregroundStyle(AppColor.mistGray.opacity(0.8))
                    TreatIconView(kind: .freshFruit, size: 28)
                        .offset(x: 8, y: -8)
                }
                VStack(alignment: .leading, spacing: 6) {
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
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColor.trailGreen)
                    }
                    BuddyEnergyBar(value: state.buddy.energy)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    /// 4つのおやつを画面内に収めて表示する一覧カード。
    private var treatsCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 8) {
                Label("home.treats", systemImage: "gift")
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColor.deepForest)

                HStack(alignment: .top, spacing: 6) {
                    ForEach(state.treats) { treat in
                        VStack(spacing: 5) {
                            TreatIconView(kind: treat.kind, size: 36)
                            Text(treat.kind.titleKey)
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundStyle(AppColor.deepForest)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .frame(maxWidth: .infinity, minHeight: 24)
                            Text("\(treat.ownedCount)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(AppColor.trailGreen)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(AppColor.softMint.opacity(0.7))
                                .clipShape(Capsule())
                        }
                        // 4件を均等幅にして、横スクロールなしで画面内に収める。
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 2)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Phase 0用の広告プレースホルダー。
    private var adPlaceholder: some View {
        AppCard {
            HStack(spacing: 10) {
                Image(systemName: "photo")
                    .font(.system(size: 18))
                    .foregroundStyle(AppColor.mistGray.opacity(0.7))
                    .frame(width: 36, height: 28)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColor.mistGray.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [4]))
                    }
                VStack(alignment: .leading, spacing: 2) {
                    Text("home.premium")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColor.deepForest)
                    Text("home.premium.description")
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColor.mistGray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                Spacer()
                Text("Ad")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.mistGray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    /// 比率レイアウトに使う各セクションの高さを計算する。
    /// - Parameters:
    ///   - screenHeight: 画面全体の高さ。
    ///   - headerHeight: ヘッダー領域の高さ。
    ///   - topPadding: 上余白。
    ///   - bottomPadding: タブバー回避を含む下余白。
    ///   - verticalSpacing: 要素間の余白。
    /// - Returns: 各セクションに割り当てる高さ。
    private func sectionHeights(
        screenHeight: CGFloat,
        headerHeight: CGFloat,
        topPadding: CGFloat,
        bottomPadding: CGFloat,
        verticalSpacing: CGFloat
    ) -> HomeSectionHeights {
        // 広告を表示する場合は「距離・相棒・おやつ・ボタン・広告」の5領域、
        // 表示しない場合は広告を除いた4領域として、必要な余白量を計算する。
        let visibleSectionCount = state.showsAdPlaceholder ? 5.0 : 4.0
        let spacingHeight = verticalSpacing * visibleSectionCount
        let availableHeight = screenHeight - headerHeight - topPadding - bottomPadding - spacingHeight
        let minimumHeights = HomeSectionHeights(distance: 132, buddy: 126, treats: 152, buttons: 56, ad: 58)

        // ボタン領域は固定高さにするため、残りの可変領域だけで最低高さを比較する。
        // 広告ありなら広告分を含め、広告なしなら広告分を除外して最低必要高さを出す。
        let variableMinimumHeight = state.showsAdPlaceholder
            ? minimumHeights.total - minimumHeights.buttons
            : minimumHeights.totalWithoutAd - minimumHeights.buttons
        let variableAreaHeight = max(availableHeight - minimumHeights.buttons, variableMinimumHeight)

        // variableAreaHeightは1領域分ではなく、距離・相棒・おやつ・広告に分配する可変領域全体の高さ。
        // 可変領域の比率は、広告ありなら「距離3:相棒2:おやつ2:広告1」の合計8、
        // 広告なしなら「距離3:相棒2:おやつ2」の合計7として配分する。
        let distanceWeight = 3.0
        let buddyWeight = 2.0
        let treatsWeight = 2.0
        let adWeight = state.showsAdPlaceholder ? 1.0 : 0.0
        let totalVariableWeight = distanceWeight + buddyWeight + treatsWeight + adWeight

        // 例: 広告ありで可変領域全体が400ptなら、距離は 400 * 3 / 8 = 150pt、
        // 相棒とおやつは 400 * 2 / 8 = 100pt、広告は 400 * 1 / 8 = 50pt になる。
        // 例: 広告なしで可変領域全体が350ptなら、距離は 350 * 3 / 7 = 150pt、
        // 相棒とおやつは 350 * 2 / 7 = 100pt になる。

        // ボタン本体は固定高さなので、ボタン領域だけを膨らませず余白を他セクションへ配分する。
        return HomeSectionHeights(
            distance: max(variableAreaHeight * distanceWeight / totalVariableWeight, minimumHeights.distance),
            buddy: max(variableAreaHeight * buddyWeight / totalVariableWeight, minimumHeights.buddy),
            treats: max(variableAreaHeight * treatsWeight / totalVariableWeight, minimumHeights.treats),
            buttons: minimumHeights.buttons,
            ad: state.showsAdPlaceholder ? max(variableAreaHeight * adWeight / totalVariableWeight, minimumHeights.ad) : 0
        )
    }
}

/// Home画面の各セクションに割り当てる高さ。
private struct HomeSectionHeights {
    /// 今日の距離カードの高さ。
    let distance: CGFloat
    /// 相棒カードの高さ。
    let buddy: CGFloat
    /// おやつカードの高さ。
    let treats: CGFloat
    /// 操作ボタン領域の高さ。
    let buttons: CGFloat
    /// 広告領域の高さ。
    let ad: CGFloat

    /// 広告を含む合計高さ。
    var total: CGFloat {
        distance + buddy + treats + buttons + ad
    }

    /// 広告を除く合計高さ。
    var totalWithoutAd: CGFloat {
        distance + buddy + treats + buttons
    }
}
