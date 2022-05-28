こちらは「UaaLを組み込んだネイティブアプリ上でシミュレーター向けにビルドできない問題を解消する」の章のサンプルプロジェクトです。

**バージョン**

- Unity 2021.3.3f1
- Xcode 13.4


# 動作確認手順について

Unity側のビルド(`UnityFramework`)はサイズが大きいためにバージョン管理しておりません。<br>
サンプルのネイティブアプリをビルドして動かす際には以下の手順に従ってUnity側をビルドする必要があります。<br>

1. `./UnityProject`を開いたらPlatformを「iOS」に切り替える
2. 「[Player Settings -> Target SDK](https://docs.unity3d.com/Manual/class-PlayerSettingsiOS.html#Config-Device)」にて動かしたい方を指定
    - 実機 : [DeviceSDK](https://docs.unity3d.com/ScriptReference/iOSSdkVersion.DeviceSDK.html)
    - シミュレーター : [SimulatorSDK](https://docs.unity3d.com/ScriptReference/iOSSdkVersion.SimulatorSDK.html)
3. Build Settingsを表示し、そのままBuildを実行
    - **この際にビルドの出力先は必ず`./UnityProject/Builds/UnityFramework`を指定すること** (xcworkspace側でこのパスを見るようにしているため)

Unity側のビルドが完了したら`./XcodeProject/UaaLExample.xcworkspace`を開き、2の選択に応じて実行する端末 or シミュレーターを選択した上でBuild & Runすることで動くはず

