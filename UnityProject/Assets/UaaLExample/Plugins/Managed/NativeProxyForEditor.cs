using System;
using UnityEngine;

namespace UaaLExample.Plugins.Managed
{
    public sealed class NativeProxyForEditor : INativeProxy
    {
#pragma warning disable 0414
        public event Action<float> OnChangeIntensityFromNative = null;
#pragma warning restore 0414

        public void Ready()
        {
            Debug.Log("エディタからの呼び出し");
        }

        public void SetIntensity(float intensity)
        {
            Debug.Log("エディタからの呼び出し");
        }
    }
}