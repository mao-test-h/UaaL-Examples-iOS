using System;

namespace UaaLExample.Plugins.Managed
{
    /// <summary>
    /// ネイティブとの呼び出し規約
    /// </summary>
    public interface INativeProxy
    {
        /// <summary>
        /// intensityの変更通知 [Native -> Unity]
        /// </summary>
        event Action<float> OnChangeIntensityFromNative;

        /// <summary>
        /// Unityのセットアップ完了通知 [Unity -> Native]
        /// </summary>
        void Ready();

        /// <summary>
        /// intensityの設定 [Unity -> Native]
        /// </summary>
        void SetIntensity(float intensity);
    }
}