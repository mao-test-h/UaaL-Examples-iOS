#if UNITY_IOS
using System;
using System.Runtime.InteropServices;

namespace UaaLExample.Plugins.Managed
{
    public sealed class NativeProxyIOS : INativeProxy
    {
        public NativeProxyIOS()
        {
            RegisterChangeIntensityDelegate();
        }

        public event Action<float> OnChangeIntensityFromNative
        {
            add => OnChangeIntensityInternal += value;
            remove => OnChangeIntensityInternal -= value;
        }

        public void Ready()
        {
            [DllImport("__Internal", EntryPoint = "callReady")]
            static extern void CallReady();

            CallReady();
        }

        public void SetIntensity(float intensity)
        {
            [DllImport("__Internal", EntryPoint = "callSetIntensity")]
            static extern void CallSetIntensity(Single intensity);

            CallSetIntensity(intensity);
        }

        static void RegisterChangeIntensityDelegate()
        {
            [AOT.MonoPInvokeCallbackAttribute(typeof(OnChangeIntensityDelegate))]
            static void CallChangeIntensity(Single intensity)
            {
                OnChangeIntensityInternal?.Invoke(intensity);
            }

            [DllImport("__Internal", EntryPoint = "callRegisterChangeIntensityDelegate")]
            static extern void CallRegisterChangeIntensityDelegate(
                [MarshalAs(UnmanagedType.FunctionPtr)] OnChangeIntensityDelegate @delegate);

            CallRegisterChangeIntensityDelegate(CallChangeIntensity);
        }

        // ネイティブから呼び出されるコールバック
        static event Action<float> OnChangeIntensityInternal = null;

        // 関数ポインタとの変換用デリゲート
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        delegate void OnChangeIntensityDelegate([MarshalAs(UnmanagedType.R4)] Single intensity);
    }
}
#endif