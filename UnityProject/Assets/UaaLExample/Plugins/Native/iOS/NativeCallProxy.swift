import Foundation

/// ネイティブ側からintensityの設定を適用するための関数ポインタ
public typealias OnChangeIntensityDelegate = @convention(c) (Float32) -> Void

public protocol NativeCallsProtocol {
    /// Unityのセットアップ完了通知 [Unity -> Native]
    func onReady()

    /// intensityの設定 [Unity -> Native]
    func onChangeIntensityFromUnity(_ intensity: Float32)

    /// 関数ポインタの登録
    func registerDelegate(_ delegate: @escaping OnChangeIntensityDelegate)
}

public final class FrameworkLibAPI {
    static var api: NativeCallsProtocol? = nil

    public static func registerAPIforNativeCalls(_ api: NativeCallsProtocol) {
        FrameworkLibAPI.api = api
    }
}

// MARK:- P/Invoke

@_cdecl("ready")
func ready() {
    FrameworkLibAPI.api?.onReady()
}

@_cdecl("setIntensity")
func setIntensity(_ intensity: Float32) {
    FrameworkLibAPI.api?.onChangeIntensityFromUnity(intensity)
}

@_cdecl("registerDelegate")
public func registerDelegate(_ delegate: @escaping OnChangeIntensityDelegate) {
    FrameworkLibAPI.api?.registerDelegate(delegate)
}
