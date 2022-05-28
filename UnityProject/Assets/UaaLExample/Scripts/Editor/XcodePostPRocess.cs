using System.IO;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;

namespace UaaLExample.Editor
{
    static class XcodePostProcess
    {
        // 参考: https://tech.mirrativ.stream/entry/2020/10/20/100000
        [PostProcessBuild]
        static void OnPostProcessBuild(BuildTarget target, string path)
        {
            if (target != BuildTarget.iOS) return;

            var projectPath = PBXProject.GetPBXProjectPath(path);
            var project = new PBXProject();
            project.ReadFromString(File.ReadAllText(projectPath));

            var targetGuid = project.GetUnityFrameworkTargetGuid();

            // `Data`フォルダを[Build Phase -> Copy Bundle Resources]に追加
            var dataPathGuid = project.FindFileGuidByProjectPath("Data");
            var resPhaseGuid = project.GetResourcesBuildPhaseByTarget(targetGuid);
            project.AddFileToBuildSection(targetGuid, resPhaseGuid, dataPathGuid);

            // Swift version
            project.SetBuildProperty(targetGuid, "SWIFT_VERSION", "5.0");

            project.WriteToFile(projectPath);
        }
    }
}