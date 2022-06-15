import SwiftUI

/// UaaLのViewをSwiftUIのViewとして扱うやつ
struct UnityView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        // TODO: 現状SwiftUIのCanvasPreviewで表示させる場合にはコードを書き換えるワークアラウンドを取る必要があるので注意...
        // NOTE:
        // 前提としてCanvasPreviewでUaaLのコードを含めて表示しようとすると、コンパイルエラーが発生すると言う問題がある。
        // なので本来ならプリプロセス処理(#if ~ #endif)を挟んで「CanvasPreview時ならダミーを表示する」と言う分岐を組みたいところだが...
        // CanvasPreviewの判定処理(`isCanvasPreview`)はランタイムでしか判定を取れないので↑を組むことが出来ない...
        // → 故に今はCanvasPreviewを使うときには一時的にUaaLにコンパイルが含まれないようにする必要がありそう。。
#if targetEnvironment(simulator)
        // SimulatorでUaaLを表示したい場合には前者を、CanvasPreviewで表示したい場合には後者を返すようにコードを書き換えて
        let view = Unity.shared.view
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

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // do noting
    }

    // SwiftUIのCanvasPreviewでの実行中かどうかの判定
    private var isCanvasPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

struct UnityView_Previews: PreviewProvider {
    static var previews: some View {
        UnityView()
    }
}
