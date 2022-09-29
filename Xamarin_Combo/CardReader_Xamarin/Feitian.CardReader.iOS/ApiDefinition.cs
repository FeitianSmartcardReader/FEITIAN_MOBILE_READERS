using System;

using ObjCRuntime;
using Foundation;
using UIKit;

namespace Feitian.CardReader.Library.iOS
{
    // @protocol ReaderInterfaceDelegate <NSObject>
    [Protocol, Model]
    [BaseType(typeof(NSObject))]
    interface ReaderInterfaceDelegate
    {
        [Abstract]
       //@required - (void) findPeripheralReader:(NSString*) readerName;
        [Export("findPeripheralReader:")]
        void findPeripheralReader(string devicename);

        // @required -(void)readerInterfaceDidChange:(BOOL)attached;
        //[Abstract]
        //[Export("readerInterfaceDidChange:")]
        //void ReaderInterfaceDidChange(bool attached);

        [Abstract]
        [Export("readerInterfaceDidChange:bluetoothID:")]
        void ReaderInterfaceDidChange(bool attached, string bluetoothID);


        // @required -(void)cardInterfaceDidDetach:(BOOL)attached;
        [Abstract]
        [Export("cardInterfaceDidDetach:")]
        void CardInterfaceDidDetach(bool attached);
        // - (void) didGetBattery:(NSInteger)battery;
        [Abstract]
        [Export("didGetBattery:")]
        void didGetBattery(int battery);

    }

    interface IReaderInterfaceDelegate { }

    // @interface ReaderInterface : NSObject
    [BaseType(typeof(NSObject))]
    interface ReaderInterface
    {
        // -(void)setDelegate:(id<ReaderInterfaceDelegate>)delegate;
        [Export("setDelegate:")]
        void SetDelegate(IReaderInterfaceDelegate @delegate);

        // -(BOOL)isReaderAttached;
        [Export("isReaderAttached")]
        bool IsReaderAttached { get; }

        // -(BOOL)isCardAttached;
        [Export("isCardAttached")]
        bool IsCardAttached { get; }
        //- (BOOL)connectPeripheralReader:(NSString *)readerName timeout:(float)timeout;
        //[Export("connectPeripheralReader:timeout")]
        //bool connectPeripheralReader(string readerName, float time);


        // - (void) disConnectCurrentPeripheralReader;
        [Export("disConnectCurrentPeripheralReader")]
        bool disConnectCurrentPeripheralReader{ get; }

        //- (void) setAutoPair:(BOOL) autoPair;
        [Export("setAutoPair:")]
        bool setAutoPair(bool autoPair);


    }

    //interface FTDeviceType { }
    // @interface FTDeviceType : NSObject
    [BaseType(typeof(NSObject))]
    interface FTDeviceType
    {

        // +(void) setDeviceType:(FTDEVICETYPE) deviceType;
        //type = 0,1,2
        [Export("setDeviceType:")]
        static void SetDeviceType(int type) {}

       // +(FTDEVICETYPE) getDeviceType;
       [Export("getDeviceType")]
       static int getDeviceType { get; }


    }
    







    //partial interface Constants
    //{
    //    // extern SCARD_IO_REQUEST g_rgSCardT0Pci;
    //    [Field("g_rgSCardT0Pci", "__Internal")]
    //    SCARD_IO_REQUEST g_rgSCardT0Pci { get; }

    //    // extern SCARD_IO_REQUEST g_rgSCardT1Pci;
    //    [Field("g_rgSCardT1Pci", "__Internal")]
    //    SCARD_IO_REQUEST g_rgSCardT1Pci { get; }

    //    // extern SCARD_IO_REQUEST g_rgSCardRawPci;
    //    [Field("g_rgSCardRawPci", "__Internal")]
    //    SCARD_IO_REQUEST g_rgSCardRawPci { get; }
    //}
}


