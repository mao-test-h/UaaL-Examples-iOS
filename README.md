こちらは「[UaaLを`XCFramework`化することで実機とシミュレーターの両方で動かせるようにする](https://qiita.com/mao_/items/9874c1efa280ed4bb399#uaal%E3%82%92xcframework%E5%8C%96%E3%81%99%E3%82%8B%E3%81%93%E3%81%A8%E3%81%A7%E5%AE%9F%E6%A9%9F%E3%81%A8%E3%82%B7%E3%83%9F%E3%83%A5%E3%83%AC%E3%83%BC%E3%82%BF%E3%83%BC%E3%81%AE%E4%B8%A1%E6%96%B9%E3%81%A7%E5%8B%95%E3%81%8B%E3%81%9B%E3%82%8B%E3%82%88%E3%81%86%E3%81%AB%E3%81%99%E3%82%8B)」のサンプルプロジェクトです。

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
