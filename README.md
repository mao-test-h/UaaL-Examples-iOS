こちらは「UaaLをiOS端末とシミュレーターの両方で動かせるようにする」の章のサンプルプロジェクトです。

**バージョン**

- Unity 2021.3.3f1
- Xcode 13.4

# 動作確認手順について

Unity側のビルドを含んでいる`UnityFramework.xcframework`はサイズが大きいためにバージョン管理しておりません。<br>
サンプルのネイティブアプリをビルドして動かす際には以下の手順に従って`UnityFramework.xcframwork`をビルドする必要があります。<br>

1. `./UnityProject`を開いたらPlatformを「iOS」に切り替える
2. Unityのメニューより「Build -> Build for iOS」を選択
    - これによって`DeviceSDK`と`SimulatorSDK`の両方がビルドされます
3. 2が完了したら`./UnityProject/build_for_xcframework.command`を実行
    - 実態はシェルスクリプトなので、コマンドライン上からも実行可能
    - これによって2の手順でビルドされたものから`UnityFramework.xcframework`がビルドされます
4. 成功したら`./UnityProject/Builds`以下に`UnityFramework.xcframework`が出来上がるので、それを`./XcodeProject/UaaLExample`以下にコピー

あとは`./XcodeProject/UaaLExample.xcworkspace`を開いてBuild & Runすれば実機 or シミュレーターのどちらでも動くはず
