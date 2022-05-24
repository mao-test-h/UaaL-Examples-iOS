import UIKit
import SwiftUI
import Combine

final class MainViewController: UIViewController {

    private let viewState = MainViewState()
    private var cancellableSet = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainViewController = UIHostingController(rootView: MainView(with: viewState))
        guard let mainView = mainViewController.view else {
            return
        }

        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])

        // Data binding.
        viewState.$intensity.sink { value in
                Unity.shared.setIntensity(with: Float32(value))
            }
            .store(in: &cancellableSet)

        Unity.shared.intensityDelegate = viewState
    }
}

final class MainViewState: ObservableObject {
    @Published var intensity: Double = 0.5
}

extension MainViewState: IntensityDelegate {
    func onChangeIntensityFromUnity(_ intensity: Float32) {
        self.intensity = Double(intensity)
    }
}
