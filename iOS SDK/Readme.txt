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
