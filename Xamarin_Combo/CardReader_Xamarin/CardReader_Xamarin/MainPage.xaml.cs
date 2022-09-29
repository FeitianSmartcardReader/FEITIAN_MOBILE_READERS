using System;
using System.Collections.Generic;
using Xamarin.Forms;

namespace CardReader_Xamarin
{
    public partial class MainPage : ContentPage
    {
        List<String> mResultList = new List<string> { };
        CardReaderInterface cardReader = null;
        int type = -1;
        [Obsolete]
        public MainPage()
        {
            InitializeComponent();
            DependencyService.Register<CardReaderInterface>();
            cardReader = DependencyService.Get<CardReaderInterface>();
            cardReader.CardReader_Init(DK.FTREADER_TYPE_USB, mylistView, mResultList, picker_USBReaderName);
        }

        void Btn_Clear_Clicked(object sender, System.EventArgs e)
        {
            mResultList.Clear();
            List<String> mResultList1 = new List<string> { };
            mResultList1.AddRange(mResultList);
            mylistView.ItemsSource = mResultList1;
        }
                
        void OnClickSelectedIndexChanged_ReaderType(object sender, EventArgs e)
        {
            int selectedIndex = picker_ReaderType.SelectedIndex;
            type = selectedIndex;
            if (selectedIndex == 0)
            {
                picker_USBReaderName.IsEnabled = true;
                cardReader.CardReader_Init(DK.FTREADER_TYPE_USB, mylistView, mResultList, picker_USBReaderName);
            }
            else if (selectedIndex == 1)
            {
                picker_USBReaderName.IsEnabled = false;
                cardReader.CardReader_Init(DK.FTREADER_TYPE_BT3, mylistView, mResultList, picker_USBReaderName);
            }else if (selectedIndex == 2)
            {
                picker_USBReaderName.IsEnabled = false;
                cardReader.CardReader_Init(DK.FTREADER_TYPE_BT4, mylistView, mResultList, picker_USBReaderName);
            }
        }
        void OnClickSelectedIndexChanged_Instruct(object sender, EventArgs e)
        {
            if (type == -1)
            {
                cardReader.ShowMessage("Please select card reader type first.！");
                return;
            }
            int selectedIndex = picker_Instruct.SelectedIndex;
            if (selectedIndex == 0)//Get Slot Status
            {
                cardReader.ShowMessage("Get Slot Status:");
                cardReader.CardReader_GetSlotstatus();
            }
            else if (selectedIndex == 1)//Get SN
            {
                cardReader.ShowMessage("Get SN:");
                cardReader.CardReader_GetSN();
            }
            else if (selectedIndex == 2)//Get Type
            {
                cardReader.ShowMessage("Get Type");
                cardReader.CardReader_GetDeviceType();
            }
            else if (selectedIndex == 3)//Get FireWare
            {
                cardReader.ShowMessage("Get FireWare");
                cardReader.CardReader_GetFirmVersion();
            }
            else if (selectedIndex == 4)//Get Uid
            {
                cardReader.ShowMessage("Get Uid");
                cardReader.CardReader_GetUid();
            }
            else if (selectedIndex == 5)//Get Lib Version
            {
                cardReader.ShowMessage("Get Lib Version");
                cardReader.CardReader_GetLibVersion();
            }
            else if (selectedIndex == 6)//Get MenuFacturer
            {
                cardReader.ShowMessage("Get ManuFacturer");
                cardReader.CardReader_GetManufacturer();
            }
            else if (selectedIndex == 7)//Get HandWare Info
            {
                cardReader.ShowMessage("Get HandWare Info");
                cardReader.CardReader_GetHardwareInfo();
            }
            else if (selectedIndex == 8)//Get Reader Name
            {
                cardReader.ShowMessage("Get Reader Name");
                cardReader.CardReader_GetReaderName();
            }
            else if (selectedIndex == 9)//Get BleFirmWare Version
            {
                cardReader.ShowMessage("Get BleFirmWare Version");
                cardReader.CardReader_GetBleFirmVersion();
            }
            else if (selectedIndex == 10)//Open Auto TurnON
            {
                cardReader.ShowMessage("Open Auto TurnON");
                cardReader.CardReader_AutoTurnOff(true);
            }
            else if (selectedIndex == 11)//Close Auti TurnOFF
            {
                cardReader.ShowMessage("Close Auti TurnOFF");
                cardReader.CardReader_AutoTurnOff(false);
            }
        }

        void OnClickSelectedIndexChanged_USBName(object sender, EventArgs e)
        {
            var picker = (Picker)sender;
            int selectedIndex = picker.SelectedIndex;

            if (selectedIndex != -1)
            {
                cardReader.CardReader_Open(picker.ItemsSource[selectedIndex]);
            }
        }
        void Btn_Find_Clicked(object sender, System.EventArgs e)
        {
            if (type == -1)
            {
                cardReader.ShowMessage("Please select card reader type first.！");
                return;
            }
            cardReader.CardReader_Find(type);
        }

        void Btn_Close_Clicked(object sender, System.EventArgs e)
        {
            if (type == -1)
            {
                cardReader.ShowMessage("Please select card reader type first.！");
                return;
            }
            cardReader.CardReader_Close();
        }

        void Btn_PowerOn_Clicked(object sender, System.EventArgs e)
        {
            if (type == -1)
            {
                cardReader.ShowMessage("Please select card reader type first.！");
                return;
            }
            cardReader.CardReader_PowerOn();
        }
        void Btn_PowerOFF_Clicked(object sender, System.EventArgs e)
        {
            if (type == -1)
            {
                cardReader.ShowMessage("Please select card reader type first.！");
                return;
            }
            cardReader.CardReader_PowerOFF();
        }

        void Btn_SendXFR_Clicked(object sender, System.EventArgs e)
        {
            if (type == -1)
            {
                cardReader.ShowMessage("Please select card reader type first.！");
                return;
            }
            String sendStr = xfr_data.Text;
            cardReader.CardReader_XFRSend(sendStr);
        }

        void Btn_SendESCAPE_Clicked(object sender, System.EventArgs e)
        {
            if (type == -1)
            {
                cardReader.ShowMessage("Please select card reader type first.！");
                return;
            }
            String sendStr = escape_data.Text;
            cardReader.CardReader_EscapeSend(sendStr);
        }

    }
}
