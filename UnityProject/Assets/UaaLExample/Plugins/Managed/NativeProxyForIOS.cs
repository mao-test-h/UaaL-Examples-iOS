#if UNITY_IOS
using System;
using System.Runtime.InteropServices;

namespace UaaLExample.Plugins.Managed
{
    public sealed class NativeProxyIOS : INativeProxy
    {
        public NativeProxyIOS()
        {
            RegisterDelegate(CallChangeIntensity);
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

        [DllImport("__Internal", EntryPoint = "ready")]
        static extern void CallReady();

        [DllImport("__Internal", EntryPoint = "setIntensity")]
        static extern void CallSetIntensity(Single intensity);

        [DllImport("__Internal", EntryPoint = "registerDelegate")]
        static extern void RegisterDelegate(
            [MarshalAs(UnmanagedType.FunctionPtr)] OnChangeIntensityDelegate @delegate);
    }
}
#endif