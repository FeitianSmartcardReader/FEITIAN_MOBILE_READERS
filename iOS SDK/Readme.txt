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