import Foundation

public protocol NativeCallsProtocol {
    /// Unityのセットアップ完了通知 [Unity -> Native]
    func onReady()

    /// intensityの設定 [Unity -> Native]
    func onChangeIntensityFromUnity(_ intensity: Float32)

    /// intensityの設定 [Native -> Unity]
    /// NOTE: ネイティブからintensityの設定を適用する際に呼び出すデリゲートの登録
    func registerChangeIntensityDelegate(_ delegate: @escaping (Float32) -> Void)
}

public final class FrameworkLibAPI {
    static var api: NativeCallsProtocol? = nil

    public static func registerAPIforNativeCalls(_ api: NativeCallsProtocol) {
        FrameworkLibAPI.api = api
    }
}

// MARK:- P/Invoke

/// ネイティブからintensityの設定を適用する際に呼び出す関数ポインタ
typealias OnChangeIntensityDelegate = @convention(c) (Float32) -> Void

@_cdecl("callReady")
func callReady() {
    FrameworkLibAPI.api?.onReady()
}

@_cdecl("callSetIntensity")
func callSetIntensity(_ intensity: Float32) {
    FrameworkLibAPI.api?.onChangeIntensityFromUnity(intensity)
}

@_cdecl("callRegisterChangeIntensityDelegate")
func callRegisterChangeIntensityDelegate(_ delegate: @escaping OnChangeIntensityDelegate) {
    FrameworkLibAPI.api?.registerChangeIntensityDelegate(delegate)
}
