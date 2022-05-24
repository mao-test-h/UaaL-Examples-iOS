import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = nil
    let unity: Unity = Unity.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // UaaLの初期化
        unity.application(application, didFinishLaunchingWithOptions: launchOptions) { [weak self] in
            // UaaLの読み込みが完了したら本来表示したいViewControllerに切り替える
            let viewController = MainViewController()
            self?.window?.rootViewController = viewController
        }

        // UaaLの読み込みが終わるまでの間は一時的にダミーのViewControllerを表示
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        unity.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        unity.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        unity.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        unity.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        unity.applicationWillTerminate(application)
    }
}
