#!/bin/zsh

# UnityからビルドしたiOSの実機&シミュレーター向けのビルドから`.xcframework`のビルドを行う
# 参考: https://qiita.com/tfactory/items/34f9d88f014c47221617

#----------------
CURRENT_DIR=`dirname $0`
cd $CURRENT_DIR

# 出力先
OUTPUT_PATH="${CURRENT_DIR}/Builds"

# Unityからビルドした各種`.xcodeproj`のパス
DEVICE_BUILD_PATH="${OUTPUT_PATH}/DeviceSDK/Unity-iPhone.xcodeproj"
SIMULATOR_BUILD_PATH="${OUTPUT_PATH}/SimulatorSDK/Unity-iPhone.xcodeproj"

if [ ! -d $DEVICE_BUILD_PATH ]; then
    echo "iOS実機向けのビルドが存在しない"
    return 1
fi

if [ ! -d $SIMULATOR_BUILD_PATH ]; then
    echo "iOSシミュレーター向けのビルドが存在しない"
    return 1
fi



# 1. `.xcodeproj`から`.xcarchive`をビルド

DEVICE_BUILD_ARCHIVE_PATH="${OUTPUT_PATH}/UnityFramework-Device.xcarchive"
SIMULATOR_BUILD_ARCHIVE_PATH="${OUTPUT_PATH}/UnityFramework-Simulator.xcarchive"

# 前回のビルド結果が残っている場合には先に削除
rm -rfv ${DEVICE_BUILD_ARCHIVE_PATH}
rm -rfv ${SIMULATOR_BUILD_ARCHIVE_PATH}

# 実機向けの`.xcarchive`をビルド
xcodebuild archive \
    -project "${DEVICE_BUILD_PATH}" \
    -scheme "UnityFramework" \
    -destination="iOS" \
    -archivePath "${DEVICE_BUILD_ARCHIVE_PATH}" \
    -sdk iphoneos \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

osascript -e 'display notification "Success Build UnityFramework-Device.xcarchive" sound name "Bip"'

# シミュレーター向けの`.xcarchive`をビルド
xcodebuild archive \
    -project "${SIMULATOR_BUILD_PATH}" \
    -scheme "UnityFramework" \
    -destination="iOS Simulator" \
    -archivePath "${SIMULATOR_BUILD_ARCHIVE_PATH}" \
    -sdk iphonesimulator \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

osascript -e 'display notification "Success Build UnityFramework-Simulator.xcarchive" sound name "Bip"'



# 2. `.xcarchive`から`.xcframework`をビルド

XCFRAMEWORK_PATH="${OUTPUT_PATH}/UnityFramework.xcframework"

# 前回のビルド結果が残っている場合には先に削除
rm -rfv ${XCFRAMEWORK_PATH}

# 1の手順でビルドした実機&シミュレーター向けのxcarchiveから`.xcframework`をビルド
xcodebuild -create-xcframework \
    -framework "${DEVICE_BUILD_ARCHIVE_PATH}/Products/Library/Frameworks/UnityFramework.framework" \
    -framework "${SIMULATOR_BUILD_ARCHIVE_PATH}/Products/Library/Frameworks/UnityFramework.framework" \
    -output ${XCFRAMEWORK_PATH}

osascript -e 'display notification "Success Build UnityFramework.xcframework" sound name "Bip"'



# 3. [BUILD_LIBRARY_FOR_DISTRIBUTION]を有効にしている都合で、このままだと`UnityFramework.xcframework`を組み込んだ際にエラーが発生するので対策
# 参考: https://developer.apple.com/forums/thread/123253

cd ${XCFRAMEWORK_PATH}

# エラー対策として、`.xcframework`に含まれる`*.swiftinterface`を全検索しつつ、sedコマンドで`UnityFramework.`を空文字に置換する
find . -name "*.swiftinterface" -exec sed -i -e 's/UnityFramework\.//g' {} \;

# `.swiftinterface-e` と言うファイルが出来るので削除
find . -name "*.swiftinterface-e" -exec rm -f {} \;

osascript -e 'display notification "Fix \".swiftinterface\" in xcframework" sound name "Bip"'



return 0