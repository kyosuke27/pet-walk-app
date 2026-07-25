import SwiftUI

/// 通知、単位、プライバシーなどを管理するSettings画面。
struct SettingsScreen: View {
    /// Settings画面の表示状態。
    let state: SettingsState
    /// Settings画面のイベント通知先。
    let onEvent: (SettingsEvent) -> Void

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    headerView
                    preferencesSection
                    singleRowSection(titleKey: "settings.privacy", systemImage: "checkmark.shield", sectionKey: "settings.section.privacy") {
                        onEvent(.privacyPolicyTapped)
                    }
                    aboutCard
                }
                .padding(.horizontal, AppSpacing.screen)
                .padding(.top, 24)
                .padding(.bottom, 28)
            }
            .background(AppColor.warmIvory.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    /// 画面タイトル。
    private var headerView: some View {
        HStack {
            Text("settings.title")
                .font(AppTypography.screenTitle)
                .foregroundStyle(AppColor.deepForest)
            Spacer()
            Image(systemName: "gearshape.fill")
                .font(.system(size: 36))
                .foregroundStyle(AppColor.trailGreen)
        }
    }

    /// Preferencesセクション。
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("settings.section.preferences")
            AppCard {
                VStack(spacing: 0) {
                    Toggle(isOn: Binding(
                        get: { state.notificationsEnabled },
                        set: { onEvent(.notificationsChanged($0)) }
                    )) {
                        Label("settings.notifications", systemImage: "bell")
                            .font(AppTypography.cardTitle)
                    }
                    .tint(AppColor.trailGreen)
                    .foregroundStyle(AppColor.deepForest)
                    Divider()
                        .padding(.vertical, 16)
                    HStack {
                        Label("settings.distanceUnit", systemImage: "ruler")
                            .font(AppTypography.cardTitle)
                            .foregroundStyle(AppColor.deepForest)
                        Spacer()
                        Picker("settings.distanceUnit", selection: Binding(
                            get: { state.distanceUnit },
                            set: { onEvent(.distanceUnitChanged($0)) }
                        )) {
                            ForEach(DistanceUnit.allCases) { unit in
                                Text(unit.label).tag(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 180)
                    }
                }
            }
        }
    }

    /// 単一行の設定セクション。
    /// - Parameters:
    ///   - titleKey: 行タイトルのローカライズキー。
    ///   - systemImage: SF Symbols名。
    ///   - sectionKey: セクションタイトルのローカライズキー。
    /// - Returns: 設定セクションView。
    private func singleRowSection(titleKey: LocalizedStringKey, systemImage: String, sectionKey: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(sectionKey)
            AppCard {
                HStack {
                    Label(titleKey, systemImage: systemImage)
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColor.deepForest)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColor.mistGray)
                }
            }
            .onTapGesture(perform: action)
        }
    }

    /// Aboutカード。
    private var aboutCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("settings.section.about")
            AppCard {
                VStack(spacing: 10) {
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(AppColor.trailGreen)
                        .frame(width: 64, height: 64)
                        .background(AppColor.softMint)
                        .clipShape(Circle())
                    Text("PawTrail 1.0.0")
                        .font(AppTypography.cardTitle)
                        .foregroundStyle(AppColor.deepForest)
                    Text("settings.about.message")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColor.mistGray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
        }
    }

    /// セクションタイトルを生成する。
    /// - Parameter key: タイトルのローカライズキー。
    /// - Returns: セクションタイトルView。
    private func sectionTitle(_ key: LocalizedStringKey) -> some View {
        Text(key)
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(AppColor.mistGray)
            .tracking(1.4)
    }
}
