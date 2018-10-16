#import <Foundation/Foundation.h>
#import "ft301u.h"
/**
 *  Delegate which is used to notify the appliation layer when the reader is attached/detached..
 */
typedef enum FTREADERTYPE{
    READER_UNKOWN = 0,
    READER_iR301U_DOCK,
    READER_iR301U_LIGHTING,
    READER_bR301, //bR301 B55
    READER_bR301B, //bR301 C63
    READER_bR301BLE,
    READER_bR500
}FTREADERTYPE;

typedef enum FTDEVICETYPE{
    EMPTY_DEVICE = 0,
    IR301_AND_BR301 = 1,
    BR301BLE_AND_BR500 = 2,
}FTDEVICETYPE;

@protocol ReaderInterfaceDelegate<NSObject>
@required

/**
 *  Delegate to be called when our custom version of the 301 has been attached or detached (regardless of whether a card is inserted or not).
 *  This should only be called on a background thread (not the main thread).
 *  You should assume that an application implemenation of this delegate will call [ReaderInterface cardInterface] to obtian a card interface.
 *  @param attached is YES if the 301 has become attached to the phone or NO if the 301 has become detached from the phone.
 */
- (void) findPeripheralReader:(NSString *)readerName;

- (void) readerInterfaceDidChange:(BOOL)attached bluetoothID:(NSString *)bluetoothID;

- (void) cardInterfaceDidDetach:(BOOL)attached;

- (void) didGetBattery:(NSInteger)battery;
@end


/**
 *  ReaderInterface class represents the attached/detached state of the reader with the iOS device.
 *  It is envisioned that attach/detach notifications will be registered to be handled by internal methods of this class.
 *  Such internal methods are assumed to be declaring in the implementation file (hidden) rather than this header.
 *  It is also envisioned that I/O notifications (NSStreamEventHasBytesAvailable, etc.) will NOT be registered to be handled by methods of this class.
 *  Instead, such notificaitons would be registered during initialization of a CardInterface class to be handled by internal
 *  methods of the CardInterface class.
 */

@interface ReaderInterface : NSObject
{
    
}

/**
 *  Set an applicaiton defined delegate to receive notificaiton that our custom 301 reader has become attached/detached.
 *  The implementation of your notifiation logic must check to see if this delegate has been provided before attempting to call it.
 *  Our applicaiton layer might set this back to nil when notifications are no longer desired.
 *  @param delegate is the caller provided delegate.
 */
- (void)        setDelegate:(id<ReaderInterfaceDelegate>)delegate;

/**
 *  Query if our custom version of the 301 is currently attached to the phone.
 *  @return YES if the 301 is attached to the phone.  NO if the 301 is detached from the phone.
 */
- (BOOL)        isReaderAttached;
/**
 *  Query if the card is currently attached to the 301.
 *  @return YES if the card is attached to the 301.  NO if the card is detached from the 301.
 */
- (BOOL)        isCardAttached;

/**
 *depend on the readerName to Connect Peripheral Readr
 *timeout is a number need set by customer, the lib will try to connect reader, but if the reader already turn off or had long distance between iOS and reader, then after that time, will return connection failure
 */
- (BOOL)connectPeripheralReader:(NSString *)readerName timeout:(float)timeout;

/**
 *disConnect the current Peripheral Reader
 */
- (void)disConnectCurrentPeripheralReader;

/**
 *set auto pair YES or NOT,default is YES
 */
- (void)setAutoPair:(BOOL)autoPair;

@end

/**
 *  DeviceType class is used to set/get device type.
 *  Now it supports IR301 and BR301. It must be set one type before you use other function.
 */

@interface FTDeviceType : NSObject

/**
 *  Set an device type you will use.
 *  @param deviceType is the type you will use. Now it supports IR301 and BR301.
 */
+(void)setDeviceType:(FTDEVICETYPE) deviceType;

/**
 *  Get the device type which you are using now.
 *  @return IR301 or BR301.
 */
+(FTDEVICETYPE)getDeviceType;

@end
