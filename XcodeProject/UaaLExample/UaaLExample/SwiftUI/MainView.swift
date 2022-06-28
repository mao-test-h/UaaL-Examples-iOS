import SwiftUI

struct MainView: View {
    @ObservedObject private var unityViewState = UnityViewState()
    @ObservedObject private var state: MainViewState
    @State private var showingModal = false

    init(with state: MainViewState) {
        self.state = state
    }

    var body: some View {
        GeometryReader { gr in
            VStack {
                Spacer()
                Button("Show fullScreenCover") {
                    // モーダルを開く前に現時点のUnityViewを非表示にしておく
                    unityViewState.isPresenting = false
                    showingModal.toggle()
                }
                .fullScreenCover(isPresented: $showingModal, onDismiss: {
                    // モーダルを閉じた後にUnityViewを復帰させる
                    unityViewState.isPresenting = true
                }) {
                    ModalView()
                }

                Spacer()
                Slider(value: $state.intensity, in: 0...1)
                    .padding(.leading, 32)
                    .padding(.trailing, 32)

                Spacer()
                UnityView(with: unityViewState)
                    .frame(width: gr.size.width / 1.5, height: gr.size.height / 1.5)
                    .onAppear {
                        unityViewState.isPresenting = true
                    }

                Spacer()
            }
        }
    }
}

struct ModalView: View {
    @ObservedObject private var unityViewState = UnityViewState()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        GeometryReader { gr in
            VStack() {
                Spacer()
                Button("dismiss") {
                    // モーダルを閉じる前に現時点のUnityViewを非表示にしておく
                    unityViewState.isPresenting = false
                    presentationMode.wrappedValue.dismiss()
                }

                Spacer()
                UnityView(with: unityViewState)
                    .frame(width: gr.size.width / 1.5, height: gr.size.height / 1.5)
                    .onAppear {
                        // モーダルが表示されたら`OnAppear`が発火されるのでUnityViewを表示
                        unityViewState.isPresenting = true
                    }

                Spacer()
            }
            .frame(width: gr.size.width, height: gr.size.height)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group() {
            MainView(with: MainViewState())
            ModalView()
        }
    }
}
