こちらは「[シミュレーター向けにビルドしたUaaLをネイティブアプリに組み込むとビルドエラーが発生する問題を解消する](https://qiita.com/mao_/items/9874c1efa280ed4bb399#%E3%82%B7%E3%83%9F%E3%83%A5%E3%83%AC%E3%83%BC%E3%82%BF%E3%83%BC%E5%90%91%E3%81%91%E3%81%AB%E3%83%93%E3%83%AB%E3%83%89%E3%81%97%E3%81%9Fuaal%E3%82%92%E3%83%8D%E3%82%A4%E3%83%86%E3%82%A3%E3%83%96%E3%82%A2%E3%83%97%E3%83%AA%E3%81%AB%E7%B5%84%E3%81%BF%E8%BE%BC%E3%82%80%E3%81%A8%E3%83%93%E3%83%AB%E3%83%89%E3%82%A8%E3%83%A9%E3%83%BC%E3%81%8C%E7%99%BA%E7%94%9F%E3%81%99%E3%82%8B%E5%95%8F%E9%A1%8C%E3%82%92%E8%A7%A3%E6%B6%88%E3%81%99%E3%82%8B)」のサンプルプロジェクトです。

**バージョン**

- Unity 2021.3.4f1
- Xcode 13.4.1


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


## ※Apple Silicon搭載のMacで動かす場合には

Simulator実行時には**XcodeをRosetta経由で実行しておく**必要があります。
