import SwiftUI

struct MainView: View {
    @ObservedObject private var state: MainViewState

    init(with state: MainViewState) {
        self.state = state
    }

    var body: some View {
        ZStack {
            UnityView()
            VStack() {
                Slider(value: $state.intensity, in: 0...1)
                    .background(Rectangle().fill(.white))
                    .padding(.leading, 32)
                    .padding(.trailing, 32)
                    .padding(.top, 129)
                Spacer()
            }
            .frame(alignment: .top)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(with: MainViewState())
    }
}
