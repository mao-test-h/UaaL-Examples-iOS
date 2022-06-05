こちらは「[シミュレーター向けにビルドしたUaaLをネイティブアプリに組み込むとビルドエラーが発生する問題を解消する](https://qiita.com/mao_/items/9874c1efa280ed4bb399#uaal%E3%82%92xcframework%E5%8C%96%E3%81%99%E3%82%8B%E3%81%93%E3%81%A8%E3%81%A7%E5%AE%9F%E6%A9%9F%E3%81%A8%E3%82%B7%E3%83%9F%E3%83%A5%E3%83%AC%E3%83%BC%E3%82%BF%E3%83%BC%E3%81%AE%E4%B8%A1%E6%96%B9%E3%81%A7%E5%8B%95%E3%81%8B%E3%81%9B%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB%E3%81%99%E3%82%8B)」のサンプルプロジェクトです。

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

