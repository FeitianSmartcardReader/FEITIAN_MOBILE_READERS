using System;
using System.Collections.Generic;
using Xamarin.Forms;

namespace CardReader_Xamarin
{
    public interface CardReaderInterface
    {
        void CardReader_Init(int FTREADER_TYPE, ListView myListview, List<String> mResultList,Picker picker_USBReaderName);
        void CardReader_Find(int type);
        void CardReader_Close();
        void CardReader_PowerOn();
        void CardReader_PowerOFF();
        void CardReader_XFRSend(String sendata);
        void CardReader_EscapeSend(String sendata);
        void CardReader_GetSlotstatus();
        void CardReader_GetSN();
        void CardReader_GetDeviceType();
        void CardReader_GetFirmVersion();
        void CardReader_GetUid();
        void CardReader_GetManufacturer();
        void CardReader_GetHardwareInfo();
        void CardReader_GetReaderName();
        String CardReader_GetLibVersion();
        void CardReader_GetBleFirmVersion();
        void CardReader_AutoTurnOff(Boolean isOpen);
        void ShowMessage(String msg);
        void CardReader_Open(Object obj);
    }
}
