using UaaLExample.Plugins.Managed;
using UnityEngine;
using UnityEngine.UI;

namespace UaaLExample
{
    sealed class Bootstrap : MonoBehaviour
    {
        [SerializeField] Rotate _rotateObj = default;
        [SerializeField] Slider _intensitySlider = default;

        INativeProxy _nativeProxy = null;

        void Start()
        {
#if UNITY_EDITOR
            _nativeProxy = new NativeProxyForEditor();
#elif UNITY_IOS
            _nativeProxy = new NativeProxyIOS();
#else
            throw new NotImplementedException();
#endif


            _intensitySlider.SetValueWithoutNotify(_rotateObj.Intensity);
            _intensitySlider.onValueChanged.AddListener(OnSliderValueChange);
            _nativeProxy.OnChangeIntensityFromNative += intensity =>
            {
                _intensitySlider.SetValueWithoutNotify(intensity);
                _rotateObj.Intensity = intensity;
            };

            _nativeProxy.Ready();
        }

        void OnSliderValueChange(float intensity)
        {
            _nativeProxy.SetIntensity(intensity);
            _rotateObj.Intensity = intensity;
        }
    }
}