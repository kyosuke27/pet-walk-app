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
