using UnityEngine;

namespace UaaLExample
{
    public sealed class Rotate : MonoBehaviour
    {
        [Range(0f, 1f)] public float Intensity = 0.5f;

        void Update()
        {
            var intensity = Intensity * 128f;
            transform.Rotate(0, Time.deltaTime * intensity, 0);
        }
    }
}