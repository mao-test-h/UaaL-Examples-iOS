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
        /// iOSビルドの実行(Device/Simulator)
        /// </summary>
        [MenuItem("Build/Build iOS (Device & Simulator)")]
        static void BuildIOSForAllSDK()
        {
            var ret = BuildIOSInternal(iOSSdkVersion.SimulatorSDK);
            if (!ret)
            {
                return;
            }

            ret = BuildIOSInternal(iOSSdkVersion.DeviceSDK);
            if (!ret)
            {
                return;
            }

            Debug.Log("<color=green>Build iOS (Device/Simulator)</color>");
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

        static bool BuildIOSInternal(iOSSdkVersion sdkVersion)
        {
            // これを変えるとビルドする度にPlayerSettingsが更新されて差分が発生するので、終わったら元の値に戻すようにしておく
            var currentSdkVersion = PlayerSettings.iOS.sdkVersion;
            PlayerSettings.iOS.sdkVersion = sdkVersion;

            void CompleteAction()
            {
                PlayerSettings.iOS.sdkVersion = currentSdkVersion;
                AssetDatabase.Refresh();
                AssetDatabase.SaveAssets();
            }

            // `./Builds`フォルダのチェック
            var buildsPath = Application.dataPath + "/../Builds/";
            CheckAndCreateDirectory(buildsPath, deleteIfExists: false);

            // このサンプルでは既存のビルドを破棄してReplace相当の処理を行うようにする
            var buildPath = buildsPath + sdkVersion.ToString();
            CheckAndCreateDirectory(buildPath, deleteIfExists: true);

            var buildOptions = new BuildPlayerOptions
            {
                scenes = GetScenePaths,
                target = BuildTarget.iOS,
                locationPathName = buildPath,
                options = BuildOptions.None,
            };

            var result = BuildPipeline.BuildPlayer(buildOptions);
            if (result.summary.result == BuildResult.Succeeded)
            {
                CompleteAction();
                return true;
            }

            Debug.LogError($"Build Failed : {sdkVersion.ToString()}");
            CompleteAction();
            return false;
        }


        static void CheckAndCreateDirectory(string path, bool deleteIfExists)
        {
            if (deleteIfExists && Directory.Exists(path))
            {
                Directory.Delete(path);
            }

            Directory.CreateDirectory(path);
        }
    }
}