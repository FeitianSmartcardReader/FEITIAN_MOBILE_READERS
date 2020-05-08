2019/04/12
	App upgrade to 2.3.0, here is the change log:
	1. Improve App stability
	2. Modify API to get reader model name, reader name and Bluetooth ID command
	3. To build the demo source code, need to add -all_load/-ObjC
	4. Support OEM reader display
	5. Add log export function, allow the user to record communication log and export by mail, help us locate the issue.

	Lib upgrade to 3.5.45, improve below issues：
	1. Improve bR301 card slot event 
	2. Improve compatible with latest iOS 12.2
	3. Modify the API which to get reader model name
	4. Solved error when calculating the time of card timeout 
	5. Modify the lib, after call SCardReleaseContext, and call SCardReconnect/SCardConnect, return SCARD_E_READER_UNAVAILABLE
	6. Improve API to disable power saving mode, the BLE reader after 3mins will turn off automatically to saving battery, the user can disable this feature 

2019/01/19
	- Update iReader demo app, demo update to 2.0.1
	    1. Using CoreBluetooth API to scan the BLE readers and through the UUID rules to do filter
	    2. Using a thread to check the Bluetooth broadcast information each 1s, to make the BLE reader list up to date
	    3. Output the log into demo App, the user can connect their iOS device into a computer, through iTunes to export the log, this improve help us to locate the issues
	    4. Fix issue for display the battery status of Bluetooth Smart reader (bR500BLE,bR301BLE)	
2018/10/16
	Add OC basic demo, which only show few API functions in single view, avoid developer look the function simply.
2018/10/12
	OC demo using for Appstore, the binary can download from:
	https://itunes.apple.com/us/app/irockey301/id525954151?mt=8

Swift demo, it includes basic function.
