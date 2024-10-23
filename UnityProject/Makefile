# Makefile

UNITY_EDITOR_PATH := /Applications/Unity/Hub/Editor/6000.0.23f1/Unity.app/Contents/MacOS/Unity
OUTPUT_PATH := ./Builds

DEVICE_BUILD_PATH=$(OUTPUT_PATH)/DeviceSDK
DEVICE_BUILD_ARCHIVE_PATH="$(OUTPUT_PATH)/UnityFramework-Device.xcarchive"

SIMULATOR_BUILD_PATH=$(OUTPUT_PATH)/SimulatorSDK
SIMULATOR_BUILD_ARCHIVE_PATH="$(OUTPUT_PATH)/UnityFramework-Simulator.xcarchive"

XCFRAMEWORK_PATH=$(OUTPUT_PATH)/UnityFramework.xcframework


build-all:
	make build-unity-all
	make build-xcarchive-all
	make build-xcframework-all

clean:
	rm -rf $(OUTPUT_PATH)
	rm -rfv $(XCFRAMEWORK_PATH)

# Unity ---------------------------------

build-unity-all:
	make build-unity-device
	make build-unity-simulator

build-unity-device:
	${UNITY_EDITOR_PATH} -batchmode \
		-nographics \
		-silent-crashes \
		-quit \
		-buildTarget iOS \
		-projectPath ./ \
		-executeMethod UaaLExample.Editor.BuildMenu.BuildIOSForDevice
	osascript -e 'display notification "Success Build for UnityProject(Device)" sound name "Bip"'

build-unity-simulator:
	${UNITY_EDITOR_PATH} -batchmode \
		-nographics \
		-silent-crashes \
		-quit \
		-buildTarget iOS \
		-projectPath ./ \
		-executeMethod UaaLExample.Editor.BuildMenu.BuildIOSForSimulator
	osascript -e 'display notification "Success Build for UnityProject(Simulator)" sound name "Bip"'

# XCArchive ---------------------------------

build-xcarchive-all:
	make build-xcarchive-device
	make build-xcarchive-simulator

build-xcarchive-device:
	rm -rfv $(DEVICE_BUILD_ARCHIVE_PATH)
	xcodebuild archive \
		-project $(DEVICE_BUILD_PATH)/Unity-iPhone.xcodeproj \
		-scheme "UnityFramework" \
		-destination="iOS" \
		-archivePath $(DEVICE_BUILD_ARCHIVE_PATH) \
		-sdk iphoneos \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES
	osascript -e 'display notification "Success Build for Device.xcarchive" sound name "Bip"'

build-xcarchive-simulator:
	rm -rfv $(SIMULATOR_BUILD_ARCHIVE_PATH)
	xcodebuild archive \
		-project $(SIMULATOR_BUILD_PATH)/Unity-iPhone.xcodeproj \
		-scheme "UnityFramework" \
		-destination="iOS Simulator" \
		-archivePath $(SIMULATOR_BUILD_ARCHIVE_PATH) \
		-sdk iphonesimulator \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES
	osascript -e 'display notification "Success Build for Simulator.xcarchive" sound name "Bip"'


# XCFramework ---------------------------------

build-xcframework-all:
	make build-xcframework
	make repair-xcframework

build-xcframework:
	rm -rfv $(XCFRAMEWORK_PATH)
	xcodebuild -create-xcframework \
		-framework $(DEVICE_BUILD_ARCHIVE_PATH)/Products/Library/Frameworks/UnityFramework.framework \
		-framework $(SIMULATOR_BUILD_ARCHIVE_PATH)/Products/Library/Frameworks/UnityFramework.framework \
		-output ${XCFRAMEWORK_PATH}
	osascript -e 'display notification "Success Build for UnityFramework.xcframework" sound name "Bip"'

repair-xcframework:
	find . -name "*.swiftinterface" -exec sed -i -e 's/UnityFramework\.//g' {} \;
	find . -name "*.swiftinterface-e" -exec rm -f {} \;
	osascript -e 'display notification "Fix \".swiftinterface\" in xcframework" sound name "Bip"'
