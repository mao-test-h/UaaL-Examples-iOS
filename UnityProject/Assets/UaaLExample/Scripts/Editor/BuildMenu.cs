using System.Collections.Generic;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEngine;
using UnityEngine.Windows;

namespace UaaLExample.Editor
{
    static class BuildMenu
    {
        /// <summary>
        /// iOS向けにDeviceSDKとSimulatorSDKの両方のビルドを作る
        /// </summary>
        [MenuItem("Build/Build for iOS")]
        static void BuildForIOS()
        {
            var buildsPath = Application.dataPath + "/../Builds/";
            CheckAndCreateDirectory(buildsPath);

            var ret = BuildForIOSInternal(buildsPath, iOSSdkVersion.SimulatorSDK);
            if (!ret) return;

            ret = BuildForIOSInternal(buildsPath, iOSSdkVersion.DeviceSDK);
            if (!ret) return;

            Debug.Log("<color=green>Complete Build For iOS</color>");
        }

        static bool BuildForIOSInternal(string buildsPath, iOSSdkVersion sdkVersion)
        {
            PlayerSettings.iOS.sdkVersion = sdkVersion;

            var buildPath = buildsPath + sdkVersion.ToString();
            CheckAndCreateDirectory(buildPath);

            var buildOptions = new BuildPlayerOptions
            {
                scenes = GetScenePaths,
                target = BuildTarget.iOS,
                targetGroup = BuildTargetGroup.iOS,
                locationPathName = buildPath,
                options = BuildOptions.None,
            };

            var result = BuildPipeline.BuildPlayer(buildOptions);
            if (result.summary.result == BuildResult.Succeeded)
            {
                return true;
            }

            Debug.LogError($"Build Failed : {sdkVersion.ToString()}");
            return false;
        }

        static string[] GetScenePaths
        {
            get
            {
                var scenePaths = new List<string>();
                foreach (var scene in EditorBuildSettings.scenes)
                {
                    scenePaths.Add(scene.path);
                }

                return scenePaths.ToArray();
            }
        }

        static void CheckAndCreateDirectory(string path)
        {
            // このサンプルでは既存のビルドを破棄してReplace相当の処理を行うようにする
            if (Directory.Exists(path))
            {
                Directory.Delete(path);
            }

            Directory.CreateDirectory(path);
        }
    }
}