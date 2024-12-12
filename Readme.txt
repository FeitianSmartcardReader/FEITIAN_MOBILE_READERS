Get Start: http://www.pcscreader.com/docs/getting_started.html

Take a test: http://www.pcscreader.com/docs/usage.html

Install App on iOS:
https://itunes.apple.com/us/app/smartcard-reader/id525954151?mt=8

Install App on Android:
iReader: https://play.google.com/store/apps/details?id=com.ftsafe.ireader
PCSCLite: https://play.google.com/store/apps/details?id=com.ftsafe.pcscdemo&hl=en&gl=US 
Private API: https://play.google.com/store/apps/details?id=com.ftsafe.cardreader&hl=en&gl=US



User manual and Developer manual:
http://www.pcscreader.com/docs/getting_started.html

History:
2024/12/12:
	- iOS:
		v3.5.70: From this version on, support CCID-compliant readers through Apple's CryptoTokenKit framework, this version improve recognizability during hot-plugging within iOS System.
		v3.5.65: Support iR301 series readers with MFi coprocessor as external USB device through Apple's ExternalAccessory framework.
		1. Compatibility improvement for certain card, feedbacked by a customer.
		2. Upload separate libs: one for real device and the other for XCode simulator.
		According to https://forums.developer.apple.com/forums/thread/711038
	- Android: 
		Update v2.0.1.6, fix issue #47 when work with old Bluetooth model
2024/04/12
	- upload iOS_SDK_ForApplePrimitiveCCID, this version iOS SDK is specific made for Apple primitive suport for CCID compliant reader by utilizing the CryptoTokenKit framework.
2022/05/17
	- update android SDK, lib upgrade to 1.0.9.6
	- update iOS SDK, lib upgrade to 3.5.64
2020/11/04
	- Upload android sdk v1.0.8, first release version
	- Update iOS SDK to 3.5.61
2020/09/14
	- Upload android sdk v1.0.3
2020/09/02
	- Update iOS Lib to 3.5.60, add new protocol string which are com.ftsafe.ir301 and com.ftsafe.br301
2020/07/02
	- Update iOS Lib 3.5.59, add background mode support, to have support background mode, you will need add "external accessory communication" key in your settings. more details, check https://developer.apple.com/documentation/uikit/app_and_environment/scenes/preparing_your_ui_to_run_in_the_background/about_the_background_execution_sequence
2020/05/12
	- Update iReader demo, add PC/SC library which only support PCSC API
2020/05/08
    	- Update iOS SDK, check the first two bytes of UUID for connection
    	- Android SDK may update in these two weeks, the old SDK won't be using anymore
2020/4/14
	- Update iOS SDK, lib upgrade to 3.5.57
2020/1/22
	- Update iOS SDK, lib upgrade to 3.5.55
2019/4/12
	- Update android SDK, jar up to 0.7.04
	- Update iOS SDK, lib up to 3.5.45
2018/01/19
	- Update demo app, demo update to 2.0.1
	    1. Using CoreBluetooth API to scan the BLE readers and through the UUID rules to do filter
	    2. Using a thread to check the Bluetooth broadcast information each 1s, to make the BLE reader list up to date
	    3. Output the log into demo App, the user can connect their iOS device into a computer, through iTunes to export the log, this improve help us to locate the issues
	    4. Fix issue for display the battery status of Bluetooth Smart reader (bR500BLE,bR301BLE)	
	- Update iOS SDK, new lib is 3.5.40, changed debugging flag, to void compilation conflicts with client Libraries
2018/12/18
	- Update iOS SDK, new lib is 3.5.39, the change log can find in iOS folder -> readme
2018/12/04
	- Update iOS SDK, a minor update of demo code
2018/10/15
	- Update iOS SDK, add iReader basic demo to github
2018/10/12
	- Update iOS SDK, release version is 3.5.29
	- Update iOS OC Demo code, support all feitian reader, and improve UI
	- 3.5.29 support Autopair or manual pair with bR301BLE and bR500
	- 3.5.29 support get battery status for bR500, bR301BLE not support yet, we are working to add this feature
2018/6/25
	- Update iOS SDK, release version is 3.5.16
	- After call SCardEstablishContext, the scan thread will start scan the BLE device
	- The 3.5.16 lib will automaticly do scan and connect the closest reader
	- Imrpove the thread safe
	- ScardDisconnect will only disconnect smart card
	- Merger iR301 and bR301 SDK(v1.32.5) into combo SDK
	- Fixed few bugs for BLE reader
2018/4/12
	- Update Android SDK, release combo Android SDK, support R301,R502,vR504,iR301,bR301,bR301BLE,bR500 
	- Will update iOS SDK recently, the lib is working on improve, should be upgrade in two weeks.
2018/1/22 
	- Update Lib to 3.5.9, modify features of bR301BLE and bR500, modify SCardListReader API, this is debug version, and not release yet, only for test, once release will update GIT, thanks for your support.
2018/1/15 
	- Update iOS lib to 3.5.8 and Update demo code(put two demos in one SDK)
