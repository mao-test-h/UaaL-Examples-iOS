import SwiftUI

struct MainView: View {
    @ObservedObject private var state: MainViewState

    init(with state: MainViewState) {
        self.state = state
    }

    var body: some View {
        GeometryReader { gr in
            VStack {
                Spacer()
                Slider(value: $state.intensity, in: 0...1)
                    .padding(.leading, 32)
                    .padding(.trailing, 32)
                Spacer()
                UnityView()
                    .frame(width: gr.size.width / 1.5, height: gr.size.height / 1.5)
                Spacer()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(with: MainViewState())
    }
}
