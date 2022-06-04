こちらは「UaaLをiOS実機とシミュレーターの両方で動かせるようにする」の章のサンプルプロジェクトです。

**バージョン**

- Unity 2021.3.3f1
- Xcode 13.4

# 動作確認手順について

Unity側のビルドを含んでいる`UnityFramework.xcframework`はサイズが大きいためにバージョン管理しておりません。<br>
サンプルのネイティブアプリをビルドして動かす際には以下の手順に従って`UnityFramework.xcframwork`をビルドする必要があります。<br>

1. `./UnityProject/build_for_xcframework.command`を実行
    - macOSならダブルクリック、若しくはシェルスクリプトとして実行可能です
    - 内部的に以下の処理が行われます
        1. UnityのiOSビルドを実行して実機 & シミュレーター向けの2つの`Unity-iPhone.xcodeproj`を生成
        2. ビルドした`.xcodeproj`から`.xcarchive`をビルド
        3. `.xcarchive`から`.xcframework`をビルド
        4. `[BUILD_LIBRARY_FOR_DISTRIBUTION]`を有効にしている都合で、このままだと`UnityFramework.xcframework`を組み込んだ際にエラーが発生するので対策
            - 参考: [Xcode 11 XCFramework "... is not a member type of ..." error](https://developer.apple.com/forums/thread/123253)
2. 成功したら`./UnityProject/Builds`以下に`UnityFramework.xcframework`が出来上がるので、それを`./XcodeProject/UaaLExample`以下にコピー

あとは`./XcodeProject/UaaLExample.xcworkspace`を開いてBuild & Runすれば実機 or シミュレーターのどちらでも動くはず
