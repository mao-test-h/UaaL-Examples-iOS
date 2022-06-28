import SwiftUI
import Combine

/// `UnityView`の表示状態
final class UnityViewState: ObservableObject {
    @Published var isPresenting = true
}

/// UaaLのViewをSwiftUIのViewとして扱うやつ
struct UnityView: UIViewRepresentable {

    // UnityViewの表示状態
    private let unityViewEnvironment: UnityViewState

    // UnityViewを中継するためのView
    private let parentView = UIView()

    init(with unityViewEnvironment: UnityViewState) {
        self.unityViewEnvironment = unityViewEnvironment
    }

    func makeUIView(context: Context) -> some UIView {
        // `isPresenting`に応じてUaaLを表示するときのみ`parentView`の階層にぶら下げるようにする
        unityViewEnvironment.$isPresenting
            .sink {
                if $0 {
                    let unity = unityView
                    parentView.addSubview(unity)
                    unity.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        unity.topAnchor.constraint(equalTo: parentView.topAnchor),
                        unity.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                        parentView.trailingAnchor.constraint(equalTo: unity.trailingAnchor),
                        parentView.bottomAnchor.constraint(equalTo: unity.bottomAnchor)
                    ])
                } else {
                    // 非表示時には階層から外しておく
                    Unity.shared.view.removeFromSuperview()
                }
            }
            .store(in: &context.coordinator.cancellable)
        return parentView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // do noting
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        coordinator.cancellable.removeAll()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var cancellable = Set<AnyCancellable>()
    }

    private var unityView: UIView {
        // TODO: 現状、SwiftUIのCanvasPreviewで表示させる場合にはコードを書き換えるワークアラウンドを取る必要があるので注意...

        // NOTE:
        // 前提としてCanvasPreviewでUaaLのコードを含めて表示しようとすると、コンパイルエラーが発生すると言う問題がある。
        // なので本来ならプリプロセス処理(#if ~ #endif)を挟んで「CanvasPreview時ならダミーを表示する」と言う分岐を組みたいところだが...
        // CanvasPreviewの判定処理(`isCanvasPreview`)はランタイムでしか判定を取れないので↑を組むことが出来ない...
        // → 故に今はCanvasPreviewを使うときには一時的にUaaLにコンパイルが含まれないようにする必要がありそう。。

#if targetEnvironment(simulator)
        // NOTE: 用途に応じて以下の片方を有効にし、もう片方をコメントアウトすること

        // A. Simulator上でUaaLを表示したい場合にはこちらを有効にする
        let view = Unity.shared.view

        // B. CanvasPreviewを使いたい場合にはこちらを有効にする
        //let view = UIView()

        if isCanvasPreview {
            // UaaLの表示領域を分かりやすくするためにダミーで色を塗ってるだけ
            view.backgroundColor = .green
        }

        return view
#else
        return Unity.shared.view
#endif
    }

    // SwiftUIのCanvasPreviewでの実行中かどうかの判定
    private var isCanvasPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

struct UnityView_Previews: PreviewProvider {
    static var previews: some View {
        UnityView(with: UnityViewState())
    }
}
