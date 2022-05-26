#if UNITY_IOS
using System;
using System.Runtime.InteropServices;

namespace UaaLExample.Plugins.Managed
{
    public sealed class NativeProxyIOS : INativeProxy
    {
        public NativeProxyIOS()
        {
            RegisterChangeIntensityDelegate(CallChangeIntensity);
        }

        public event Action<float> OnChangeIntensityFromNative
        {
            add => OnChangeIntensityInternal += value;
            remove => OnChangeIntensityInternal -= value;
        }

        public void Ready() => CallReady();

        public void SetIntensity(float intensity) => CallSetIntensity(intensity);


        static event Action<float> OnChangeIntensityInternal = null;

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        delegate void OnChangeIntensityDelegate([MarshalAs(UnmanagedType.R4)] Single intensity);

        [AOT.MonoPInvokeCallbackAttribute(typeof(OnChangeIntensityDelegate))]
        static void CallChangeIntensity(Single intensity)
        {
            OnChangeIntensityInternal?.Invoke(intensity);
        }

        [DllImport("__Internal", EntryPoint = "callReady")]
        static extern void CallReady();

        [DllImport("__Internal", EntryPoint = "callSetIntensity")]
        static extern void CallSetIntensity(Single intensity);

        [DllImport("__Internal", EntryPoint = "callRegisterChangeIntensityDelegate")]
        static extern void RegisterChangeIntensityDelegate(
            [MarshalAs(UnmanagedType.FunctionPtr)] OnChangeIntensityDelegate @delegate);
    }
}
#endif