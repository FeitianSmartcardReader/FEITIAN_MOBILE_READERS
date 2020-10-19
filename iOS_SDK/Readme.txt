To install latest IPA, please download from Appstore

2020/10/19
	Solved the compatible issue with iOS 14 with multi-thread support
2020/09/02
	Add new string into lib, the new external protocol string apply lower-case letter, if you are using iR301, bR301, then please add below strings in your Info.plist,  External Accessory Protocol string key needs to set as below:
        iR301: com.ftsafe.ir301, com.ftsafe.iR301
        bR301: com.ftsafe.br301, com.ftsafe.bR301
	
	 If you want use App match feature, confirm below:
	 1. You have add those strings into your Info.plist file
	 2. Add notes in your order and said you need App match feature
2020/05/12
	Add PCSC Demo, which only call PCSC API
	Update iReader demo
	Upload PCSC Library, which only support PCSC API
	Rename the iReader Appstore demo
	Upload IPA for iReader and PC/SC Demo 
2020/04/14
	Update lib to 3.5.57, improve below issues:
	compatibility with bR301BD5 and bR301BLE
	Fix bug for timeout card, which test the card timeout with 30s
2020/01/22
	Lib upgrade to 3.5.55, improve below issues:
	1. Compatible with latest iOS 13.2
	2. Solved building issue with xcode 11(solved data to string convert issue)
	3. Modify the code to meet the PC/SC connection without delegate
  	4. Rename derive_key API
	5. Solved a issue which is computing the timeout API, which lead to a error while in communication
	6. Support OEM reader
	7. Change the private command for Bluetooth reader 
	8. Solved a issue when call GetDeviceType, sometimes, the EA API return 0, before start transfer data with reader, will check the self.session outputStream
	9. Solved a bug when power on the specific card
	10. Add compatible with BLE reader
	11. Add API to get reader type
2019/04/22
	Lib upgrade to 3.5.45, improve below issues：
	1. Improve bR301 card slot event 
	2. Improve compatible with latest iOS 12.2
	3. Modify the API which to get reader model name
	4. Solved error when calculating the time of card timeout 
	5. Modify the lib, after call SCardReleaseContext, and call SCardReconnect/SCardConnect, return SCARD_E_READER_UNAVAILABLE
	6. Improve API to disable power saving mode, the BLE reader after 3mins will turn off automatically to saving battery, the user can disable this feature 
2019/01/19
	Update SDK to 3.5.40, changed debugging flag, to void compilation conflicts with client Libraries
2018/12/18
	Update SDK to 3.5.39
	Re-define the internal API and values, CommunicationMutex, Dpt, isbadreadptr,ccid_error,log_msg
2018/12/04
	Update SDK to 3.5.38
	1. Fix a bug when get bR301 firmware version error 
 	2. Modify the initial value when using auto pair feature for bR301BLE and bR500
	3. Improve SCardStatus API
	4. Fix get SN error issue and fix a bug of length value when read the flash
	5. Improve thread safe, improve the stability  of card slot event
	6. Improve FtWriteFlash and FtReadFlash API
	7. Fix bug when get bR301 hardware version issue
	8. Improve SCardEstablishContext and SCardReleaseContext API
	9. New lib support arm64e,arm64,armv7s
2018/10/15
	Rename iReader OC demo to "iReader for Appstore", which only using for Appstore
	Add iReader_Basic for developer, put APIs in single view
2018/10/12
	Update iOS demo code - only objective-C
	1. Redesign the UI to meet latest iPhone style
	2. Integrate with latest lib 3.5.29
	3. Add support iR301, bR301, bR301BLE, bR500 in one App
	4. Add get reader information API, now you can get reader serial number, Bluetooth ID, Firmware version, Reader name. Model name and manufacturer from our API
	5. App support auto pair function for bR301BLE and bR500
	6. App support get battery status of reader, currently, only support bR500, you will need contact Feitian to have latest version, the exist reader cannot update firmware to support battery service.
	7. App will scan the bluetooth list each 10s
	
	Other comments:
	1. The iReader App only support one reader
	2. Auto Pair only work for bR301BLE and bR500, since these device using Bluetooth Smart technology


2018/1/15
	
	Update demo code, new iReader demo support bR301,iR301,bR301BLE and bR500
			Update lib to 3.5.8, new lib added bR301BLE and bR500 support with readerInterfaceDidChange and cardInterfaceDidDetach API


2017/8/10
	
	Update lib to 2.1.0, the new version has keep update with master code
2016/8/4
	1. 2.0.1 lib support iR301,bR301,bR301BLE,bR500
	2. Add BR301BLE_AND_BR500 private API into ft301u.h
	3. Add DeviceType Class into ReaderInterface.h
	4. Add +(void) setDeviceType:(DEVICETYPE) deviceType; into ReaderInterface.h
	Before call lib, first you need call this API to tell lib which reader plan using. 
	Macro definition is IR301_AND_BR301= 1,BR301BLE_AND_BR500 = 2
	



	/**
	 *  Set an device type you will use.
	 *  @param deviceType is the type you will use. Now it supports IR301 and BR301.
	 */
	+(void)        setDeviceType:(DEVICETYPE) deviceType;
