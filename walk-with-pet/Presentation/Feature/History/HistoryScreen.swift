import Charts
import SwiftUI

/// 日別の散歩履歴を表示する画面。
struct HistoryScreen: View {
    /// History画面の表示状態。
    let state: HistoryState
    /// History画面のイベント通知先。
    let onEvent: (HistoryEvent) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    headerView
                    summaryCard
                    recentWalksCard
                }
                .padding(.horizontal, AppSpacing.screen)
                .padding(.top, 24)
                .padding(.bottom, 14)
            }
            .background(AppColor.warmIvory.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    /// 画面タイトル。
    private var headerView: some View {
        HStack {
            Text("history.title")
                .font(AppTypography.screenTitle)
                .foregroundStyle(AppColor.deepForest)
            
            
        }
    }
    
    /// 今週のサマリーカード。
    private var summaryCard: some View {
        AppCard {
            VStack(alignment: .leading, spacing: 18) {
                HStack{
                    Text("history.thisWeek")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColor.mistGray)
                    Spacer()
                    Button {
                    } label: {
                        Image(systemName: "info.circle")
                        .foregroundStyle(AppColor.trailGreen)
                    }
                    
                }
                HStack(spacing: 18) {
                    summaryMetric(systemImage: "chart.bar.fill", value: AppFormatters.distanceText(meters: state.weeklyDistanceMeters), labelKey: "history.totalDistance")
                    summaryMetric(systemImage: "star.circle.fill", value: "\(state.treatsEarnedCount)", labelKey: "history.treatsEarned")
                    summaryMetric(systemImage: "heart.fill", value: "+\(state.averageEnergyGain)", labelKey: "history.avgEnergy")
                }
                weeklyBars
            }
        }
    }
    
    /// サマリー内の数値表示。
    /// - Parameters:
    ///   - systemImage: SF Symbols名。
    ///   - value: 表示する値。
    ///   - labelKey: 説明文のローカライズキー。
    /// - Returns: サマリー項目View。
    private func summaryMetric(systemImage: String, value: String, labelKey: LocalizedStringKey) -> some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .foregroundStyle(AppColor.trailGreen)
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(AppColor.deepForest)
                .minimumScaleFactor(0.7)
            Text(labelKey)
                .font(AppTypography.caption)
                .foregroundStyle(AppColor.mistGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    /// 今週の距離を棒グラフで表示する。
    private var weeklyBars: some View {
        let maxDistanceMeters = max(state.weeklyRecords.map(\.distanceMeters).max() ?? 0, 1000)
        
        return Chart(state.weeklyRecords) { record in
            BarMark(
                x: .value(String(localized: "history.chart.weekday"), record.weekday),
                y: .value(String(localized: "history.chart.distance"), record.distanceMeters)
            )
            .foregroundStyle(AppColor.trailGreen.opacity(0.75))
        }
        .chartYScale(domain: 0...maxDistanceMeters)
        .chartXAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.mistGray)
            }
        }
        .chartYAxis(.hidden)
        .accessibilityLabel(Text("history.weeklyChart"))
        .frame(height: 104)
    }
    
    /// 最近の散歩一覧カード。
    private var recentWalksCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("history.recentWalks")
                    .font(AppTypography.cardTitle)
                    .foregroundStyle(AppColor.deepForest)
                Spacer()
                Text("history.seeAll")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColor.trailGreen)
                    .onTapGesture {
                        onEvent(.seeAllTapped)
                    }
            }
            AppCard {
                VStack(alignment: .center,spacing: 0) {
                    ForEach(state.walkRecords) { record in
                        historyRow(record)
                            .onTapGesture {
                                onEvent(.walkRecordTapped(record.id))
                            }
                        if record.id != state.walkRecords.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    /// 履歴の1行表示。
    /// - Parameter record: 表示する散歩記録。
    /// - Returns: 散歩履歴行。
    private func historyRow(_ record: WalkRecord) -> some View {
        GeometryReader { proxy in
            // 行ごとに列幅が変わると一覧の視線移動が増えるため、カード内幅を同じ比率で3列に分けて揃える。
            let columnSpacing = 4.0
            let contentWidth = proxy.size.width - (columnSpacing * 2)
            let dateColumnWidth = contentWidth * 0.3
            let distanceColumnWidth = contentWidth * 0.3
            let rewardColumnWidth = contentWidth * 0.4
            
            HStack(alignment: .center, spacing: columnSpacing) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(AppFormatters.historyWeekdayText(record.startedAt))
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColor.deepForest)
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                    Text(AppFormatters.historyNumericDateText(record.startedAt))
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColor.mistGray)
                        .lineLimit(1)
                }
                .frame(width: dateColumnWidth, alignment: .leading)
                
                Text(AppFormatters.distanceText(meters: record.distanceMeters))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColor.deepForest)
                    .lineLimit(2)
                    .minimumScaleFactor(0.65)
                    .frame(width: distanceColumnWidth, alignment: .leading)
                
                rewardKindView(record.earnedTreatKind)
                    .frame(width: rewardColumnWidth, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 46)
        .padding(.top, 8)
    }
    
    /// 報酬種類をアイコンと名称で表示する。
    /// - Parameter treatKind: 獲得したおやつ種類。
    /// - Returns: 報酬種類View。
    private func rewardKindView(_ treatKind: TreatKind?) -> some View {
        HStack(spacing: 6) {
            if let treatKind {
                TreatIconView(kind: treatKind, size: 28)
                Text(treatKind.titleKey)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.deepForest)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            } else {
                Text("history.noReward")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.mistGray)
                    .lineLimit(1)
            }
        }
    }
}
