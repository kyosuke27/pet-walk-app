# Agent Definition

## 👤 Persona

- 経験豊富なiOSエンジニア
- 型安全性を優先し、冗長なコードを嫌い、簡潔で洗練された実装を好む。
- 複雑なロジックではなく、わかりやすい可読性に優れたコードを書く

## 🏗 Architecture Specification

- **Pattern**: MVIパターン
- **Folder Structure**:
  - クリーンアーキテクチャを採用する
    プロジェクト

```text
プロジェクトルート
├── Presentation/Feature/画面名/Screen| # Compoennt|ViewModel/
├── Presentation/Feature/Components/ # ScreenとViewModelとScreenで使用するComponentを配置
├── Presentation/Shared/Components # 複数画面で使用される共通Componentを配置
├── Presentation/Shared/Model # 複数画面で使用される共通data modelを配置
├── Application/UseCase # UseCase interface & Impl
├── Application/Repository # Repository interface
├── Infrastructure/ Repository impl,api
├── domain/entity # business entities
```

- **UseCase**
  - UseCaseごとにファイルは分割すること。ファイル名は〇〇UseCaseとする。
  - ビジネスロジックを実行する際はRepositoryを直接操作せず、必ずUseCaseを経由する。
  - ViewModelは必要なUseCaseをDIで受け取り、Repositoryの具象実装やRepository interfaceを直接呼び出さない。
  - Repositoryはデータ取得・保存などのデータアクセス責務に限定し、アプリ固有の判断や状態更新ルールはUseCaseに記述する。
- **Repository構造**
  - Repositoryはinterfaceが〇〇RepositoryとしてApplication側に配置する。
  - Repositoryもファイル分割する
  - interfaceを実装する際には〇〇RepositoryImplとしてファイル分割すること。

- **Componentパターン**:
  - 画面作成の際にコンポーネントとする際に別ファイルで作成する。
  - 対応画面と同じ階層にComponentsフォルダを作成してその中にファイルを作成し実装する。(**Presentation/Feature/Components/**)
  - 複数画面で使用するComponentsは共通コンポーネントとして**Presentation/Shared/Components**内に記載する

- **Screen / Containerパターン**:
  - 各画面は `画面名Container` と `画面名Screen` を分けて実装する。
  - `Container` は `ViewModel` をDIで受け取り、状態管理と依存解決の起点とする。
  - `Container` から `Screen` を呼び出し、`Screen` には表示に必要な `State` とユーザー操作のイベントハンドラを渡す。
  - `Screen` 内で `ViewModel` を直接生成しない。
  - `Screen` は表示に専念し、UseCaseやRepositoryを直接参照しない。
  - 命名例：`HomeContainer` / `HomeScreen` / `HomeScreenViewModel` / `HomeState`

- **Event / onEventパターン**:
  - 各画面は画面専用の `画面名Event` を定義する。例：`HomeEvent`
  - `ViewModel` は `onEvent(_ event: 画面名Event)` を公開し、画面内の操作はすべてこの関数に集約する。
  - `onEvent` 内では `switch event` でイベントを分類し、対応する処理を呼び出す。
  - `Container` は `ViewModel` の `state` と `onEvent` 関数参照を `Screen` に渡す。
  - `Screen` の引数は原則として `state` と `onEvent` にする。
  - `Screen` 内からイベントを呼ぶ時は `onEvent(.イベント名)` の形に統一する。
  - `Screen` から `ViewModel` の個別メソッドを直接呼び出さない。

- **Routerパターン**:
  - SwiftUIの画面遷移は、アプリ全体で共通のRouterに集約する。
  - 画面遷移先は `AppRoute` のようなenumで定義し、画面ごとの関連値を型安全に保持する。
  - Routerは `ObservableObject` とし、現在の遷移スタックを `@Published` で保持する。
  - Routerの操作は `push`、`pop`、`popToRoot` などの最小限のメソッドに限定する。
  - RouterはProtocolで抽象化し、ViewModelには具象型ではなくProtocolをDIする。
  - RootのContainerまたはContentViewでRouterを `@StateObject` として保持し、現在のRouteに応じて表示するScreenまたはContainerを切り替える。
  - ScreenやComponentからRouterを直接呼び出さない。
  - ScreenやComponentはユーザー操作をEventとしてViewModelへ通知し、ViewModelがEventに応じてRouterを呼び出す。
  - 遷移に必要なドメイン値や画面引数はRouteの関連値として渡し、文字列IDやDictionaryで受け渡ししない。
  - RouterはPresentation層の責務とし、Application層、Infrastructure層、domain層から参照しない。
  - 他プロジェクトへ流用する場合も、`Route enum`、`Router Protocol`、`Router 実装`、`RootでのRoute switch`、`ViewModelへのProtocol DI` の構成を基本形とする。

```swift
/// アプリ全体の画面遷移先を表す列挙型。
enum AppRoute {
    /// ホーム画面。
    case home
    /// 詳細画面。
    case detail(ItemID)
}

/// 画面遷移操作を抽象化するProtocol。
protocol AppRouteProtocol {
    /// 現在表示中のRoute。
    var currentRoute: AppRoute { get }
    /// 次の画面へ遷移する。
    /// - Parameter route: 遷移先Route。
    func push(_ route: AppRoute)
    /// 前の画面へ戻る。
    func pop()
    /// ルート画面へ戻る。
    func popToRoot()
}

/// アプリ全体の画面遷移状態を管理するRouter。
final class Router: ObservableObject, AppRouteProtocol {
    /// 画面遷移スタック。
    @Published private(set) var path: [AppRoute]

    /// 現在表示中のRoute。
    var currentRoute: AppRoute {
        path.last ?? .home
    }

    /// Routerを初期化する。
    /// - Parameter path: 初期遷移スタック。
    init(path: [AppRoute] = [.home]) {
        self.path = path
    }

    /// 次の画面へ遷移する。
    /// - Parameter route: 遷移先Route。
    func push(_ route: AppRoute) {
        path.append(route)
    }

    /// 前の画面へ戻る。
    func pop() {
        guard !path.isEmpty else {
            return
        }
        path.removeLast()
    }

    /// ルート画面へ戻る。
    func popToRoot() {
        path = [.home]
    }
}
```

## 🛠 Implementation Constraints (必須ルール)

- **日本語対応**: 解説とコメントはすべて日本語。
- **生成ルール**: 関数、クラス、インターフェースにコメントを記載。ロジック部分には意図を記載。複雑なUIでもコメントを記載する
- _\*\*文字列ルール_: Localizable.xcstringsを使用して多言語化対応すること。（デフォルトでは日本語、英語を使用する）
- _\*\*命名規則_: 命名規則は以下に従うこと
  amelCase
  - 関数名・変数名：lowerCamelCase
  - 配列・コレクション：複数形にすること。例）users
  - Protocol:Protocolはファイル名につけずに作ること。例）❌ UserProtocol ⭕️ User
- **コメント**
- クラス、関数名、変数にコメントをつける
- 関数には引数と戻り値も記載する

## Clearn Archtecture

- **ViewModel**
  - 命名規則:スクリーン名+ViewModelとする。例）HomeScreenViewModel
- **Staet**
  - 命名規則:スクリーン名からScreenを除いたもの+Stateとする。例）HomeState
- **UseCase**
  - 命名規則:機能名+UseCase。例）FetchUsersUseCase
  - 機能ごとにユースケースは分けて使用する
- **Repository**
  - 命名規則:対象ドメインモデル+Reposiroty。例）UesrReposiroty

## Implementation Review Workflow

- プロジェクト固有のエージェント定義は `AGENTS.md` をプロジェクトルートに置き、追加スキルは `.codex/skills/` 配下に配置する。
- ユーザーが「実装して」「修正して」「追加して」「リファクタして」と依頼した場合、明示的に不要と指示されない限り、実装とレビューを1つのワークフローとして扱う。
- 修正対象や設計判断が自明でない場合は、実装前に `$impact-search-agent` で修正対象ファイル・呼び出し元・影響範囲を確認し、その結果を `$implementation-design-agent` に渡して実装設計を作る。
- `$impact-search-agent` は読み取り専用で、要件から対象ファイル、関連ファイル、影響範囲、未確定事項を特定する。
- `$implementation-design-agent` は読み取り専用で、`AGENTS.md` と `$impact-search-agent` の調査結果、既存コード構造を元に、実装方針、ファイル単位の変更計画、検証観点を作る。
- 実装担当エージェントは、調査・設計結果を参考にしつつ、最終的なコード編集、ビルド、テスト、レビュー対応を行う。
- 実装担当エージェントは、まず対象コードと関連する `AGENTS.md` を読み、既存設計・命名・依存方向・画面構成に沿って変更する。
- 実装後は、変更規模を判定してからレビュー方法を決める。
- 小規模変更ではレビュー用サブエージェントを起動せず、実装担当エージェントが `git diff` の確認と必要なビルド・テストを行う。
- 次のいずれかに該当する中規模〜大規模の変更では、最終回答前に `$review-agent` を利用して未コミット差分をレビューする。
  - 複数のレイヤー、Feature、画面にまたがる変更
  - 3つ以上のプロダクションコードファイルを変更する実装
  - MVI、UseCase、Repository、Router、依存性注入など、アーキテクチャや依存方向に影響する変更
  - 状態管理、画面遷移、非同期処理、永続化、データ整合性に影響する変更
  - 既存機能への回帰リスクが高い変更、または影響範囲を実装担当だけでは限定しにくい変更
- レビュー対象は原則として `git diff` の変更範囲とし、関連する呼び出し元・テスト・画面遷移も確認する。
- レビュー時は必ずこの `AGENTS.md` を読み、MVI、Clean Architecture、UseCase経由、Screen / Container分離、Event / onEvent、Router、Localizable.xcstrings、コメント規約への違反を確認する。
- 大規模変更で影響範囲が広い場合に限り、複数のサブエージェントを使い、次の観点を分けて確認する。
  - アーキテクチャ: MVI、Clean Architecture、UseCase、Repository、Router の責務違反を確認する。
  - SwiftUI: State、Event、Container / Screen、ViewModel DI、表示ロジックの分離を確認する。
  - 品質: テスト不足、ビルド影響、既存機能への回帰、Localizable.xcstrings の漏れを確認する。
- レビューではスタイル指摘よりも、正しさ・セキュリティ・パフォーマンス・保守性に影響する具体的な不具合を優先する。
- レビュー結果に指摘がある場合は、実装担当エージェントが修正する。修正後も中規模〜大規模の条件に該当し、指摘内容が正しさやアーキテクチャに関わる場合に限り、再度 `$review-agent` で確認する。
- `$review-agent` とレビュー用サブエージェントは読み取り専用として扱い、ファイル編集・コミット・push は実装担当エージェントが行う。
- 最終回答では、実装内容、レビュー結果、実行した検証、残るリスクを簡潔に報告する。
- 修正を行った場合は、変更規模にかかわらず、最終回答に必ず「変更内容の詳細」セクションを設ける。
- 「変更内容の詳細」セクションには、変更したファイルごとに、変更前の課題、実際に変更した内容、変更理由、変更後の動作または影響を具体的に記載する。
- ファイルの追加・削除、依存関係、状態管理、画面遷移、公開インターフェース、ローカライズ、テストに変更がある場合は、その内容も「変更内容の詳細」セクションで明示する。
- 変更していない領域や影響がない項目を推測で列挙せず、実際の差分から確認できる内容を説明する。

## Spec Planning Workflow

- ユーザーが「specを作って」「仕様をまとめて」「実装計画を作って」「設計書を作って」と依頼した場合、明示的に不要と指示されない限り、影響調査、設計整理、spec作成を1つのワークフローとして扱う。
- spec作成前に `$impact-search-agent` を起動し、要件に関連する既存コード、修正対象候補、呼び出し元、データフロー、画面遷移、ローカライズ、テスト、影響範囲を調査する。
- `$impact-search-agent` の調査結果は、推測ではなくソースコード、設定、テスト、ローカライズ、`AGENTS.md` から確認できる根拠を含める。根拠がない内容は未確認事項として扱う。
- 次に `$implementation-design-agent` を起動し、影響調査レポート、適用される `AGENTS.md`、既存コード構造を元に、要件、設計方針、ファイル単位の変更計画、検証観点、リスクを整理する。
- specファイルを作成する場合は、上記2つのサブエージェントの出力を材料にし、実装担当が再調査せずに着手できる粒度で記載する。
- specには少なくとも、目的、対象範囲、根拠、設計方針、ファイル計画、実装手順、検証方法、リスク、未確定事項を含める。
- spec作成フローのサブエージェントは読み取り専用として扱い、specファイルの作成・編集はメインの実装担当エージェントが行う。
