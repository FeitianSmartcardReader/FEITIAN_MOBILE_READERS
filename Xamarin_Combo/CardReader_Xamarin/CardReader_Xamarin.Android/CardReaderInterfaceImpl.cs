using Android;
using Android.App;
using Android.Content;
using Android.Content.PM;
using Android.OS;
using Android.Util;
using AndroidX.Core.App;
using AndroidX.Core.Content;
using CardReader_Xamarin.Droid;
using Com.Ftsafe;
using Com.Ftsafe.Comm;
using Com.Ftsafe.ReaderScheme;
using System;
using System.Collections.Generic;
using Xamarin.Forms;
using Exception = Java.Lang.Exception;
using String = System.String;

[assembly: Xamarin.Forms.Dependency(typeof(CardReaderInterfaceImpl))]
namespace CardReader_Xamarin.Droid
{
    [Activity(Label = "CardReaderInterfaceImpl")]
    public class CardReaderInterfaceImpl : CardReaderInterface
    {
        private FTReader mFtReader;
        //static SelectDeviceDialog deviceDialog;
        static Context mContext;
        MyHandler mHandler;
        Xamarin.Forms.Picker picker_USBReaderName;
        int slotIndex = 0;
        Xamarin.Forms.ListView myResultListview;
        List<string> myResultList,myUSBNames;

        int type = 0;//usb

        private int REQUEST_PERMISSION_CODE = 1;
        private String[] permissions = {
            Manifest.Permission.AccessCoarseLocation,
             Manifest.Permission.AccessFineLocation
    };

    public void CardReader_Init(int FTREADER_TYPE, Xamarin.Forms.ListView myListview, List<string> mResultList, Xamarin.Forms.Picker picker)
        {
            if(mContext == null)
            {                
                Log.Error("lwk", "请先执行SetContext（Context context ）方法！");
                return;
            }

            if (ContextCompat.CheckSelfPermission(mContext, Manifest.Permission.AccessCoarseLocation) != (int)Permission.Granted)
            {
                Log.Error("lwk", "未获取权限！");
                ActivityCompat.RequestPermissions((Activity)mContext, permissions, REQUEST_PERMISSION_CODE);
            }

            myResultListview = myListview;
            myResultListview.VerticalOptions = LayoutOptions.FillAndExpand;
            myResultListview.HasUnevenRows = true;

            myResultList = mResultList;
            picker_USBReaderName = picker;
            myUSBNames = new List<string>();
            type = FTREADER_TYPE;
            mHandler = new MyHandler(RefreshUI);
            mFtReader = new FTReader(mContext, (Handler)mHandler, FTREADER_TYPE);
            //deviceDialog = new SelectDeviceDialog(mContext, mFtReader, (Handler)mHandler);
        }

        public static void setContext(Context context)
        {
            mContext = context;
        }

        private void RefreshUI(Message msg)//在主线程更新UI
        {
            String text = "";
            text = (String)msg.Obj;
            Log.Error("lwk", "Handler更新消息：" + msg.What + ", obj : " + text);
            switch (msg.What)
            {//Bluetooth device scanned
                case 128:
                case 129:
                    try {
                        //device = (BluetoothDevice)msg.Obj;//强转失败
                        Android.Bluetooth.BluetoothDevice device = (Android.Bluetooth.BluetoothDevice)msg.Obj;
                        if (device != null && device.Name != null)
                        {
                            Log.Error("lwk", "扫描到的设备：" + device.Name);
                            mFtReader.ReaderOpen(device);
                            ShowMessage("Bluetooth device has been connected.");
                            //if (deviceDialog != null)
                            //{
                            //    deviceDialog.SetData(device);
                            //}
                        }
                    }
                    catch
                    {
                        Log.Error("lwk", "强转BluetoothDevice失败！");
                    }
                    break;
                case 16:
                    if (text.Contains("USB_PERMISSION"))
                    {
                        try
                        {
                            String[] names = mFtReader.ReaderOpen(null);
                            if (names.Length != 0)
                            {
                                addSpinnerPrivate(names);
                            }
                            for (int i = 0; i < names.Length; i++)
                            {
                                myUSBNames.Add(names[i]);
                            }
                            ShowMessage("USB device has been connected.");
                        }
                        catch (FTException e)
                        {
                            e.PrintStackTrace();
                            ShowMessage("USB device connection failed.");
                            
                        }
                    }
                    break;
                case 114:
                    ShowMessage("Bluetooth device has been disconnected.");
                    break;
                case 130:
                    ShowMessage("BLE device has been disconnected.");
                    break;
                case 17:
                    ShowMessage("USB device has been inserted.");
                    break;
                case 18:
                    ShowMessage("USB device out");
                    addSpinnerPrivate(new String[] { });
                    break;
                case 131:
                    ShowMessage("Bluetooth device has been connected.");
                    break;
                default:
                    if ((msg.What & DK.CARD_IN_MASK) == DK.CARD_IN_MASK)
                    {
                        //Card in.
                        ShowMessage("Card slot " + (msg.What % DK.CARD_IN_MASK) + " in.");
                        return;
                    }
                    else if ((msg.What & DK.CARD_OUT_MASK) == DK.CARD_OUT_MASK)
                    {
                        //Card out.
                        ShowMessage("Card slot " + (msg.What % DK.CARD_IN_MASK) + " out.");
                        return;
                    }
                    break;
            }
        }

        private void addSpinnerPrivate(String[] devNameArray)
        {
            //ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.sp_device_name)).getAdapter());
            if (picker_USBReaderName != null || myUSBNames != null)
            {
                myUSBNames.Clear();
            }
            for (int i = 0; i < devNameArray.Length; i++)
            {
                String devName = devNameArray[i];
                if (devName != null)
                {
                    addSpinnerPrivate(devName);
                    picker_USBReaderName.SelectedIndex = 0;
                    //picker_USBReaderName.Title = devName;
                }
            }
        }

        private void addSpinnerPrivate(String devName)
        {
            myUSBNames.Add(devName);
            picker_USBReaderName.ItemsSource = myUSBNames;
        }

        public void CardReader_Find(int type)
        {
            if (ContextCompat.CheckSelfPermission(mContext, Manifest.Permission.AccessCoarseLocation) != (int)Permission.Granted)
            {
                ShowMessage("Permission not obtained.");
                return;
            }
            if (type == 0)
            {//usb
                try
                {
                    mFtReader.ReaderFind();
                }
                catch (FTException e)
                {
                    ShowMessage("USB device connection failed.");
                    e.PrintStackTrace();
                }
            }
            else
            {
                Log.Error("lwk", "执行ReaderFind方法！");
                //deviceDialog.Show();
                mFtReader.ReaderFind();
                Log.Error("lwk", "执行ReaderFind方法完毕！");
            }
        }

        public void CardReader_AutoTurnOff(bool isOpen)
        {
            try
            {
                byte[] result = mFtReader.FT_AutoTurnOffReader(isOpen);
                ShowMessage((isOpen ? "open" : "close") + " auto turn off : " + Utility.Bytes2HexStr(result));
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage((isOpen ? "open" : "close") + " auto turn off \n" + e.GetBaseException());
            }
        }

        public void CardReader_Close()
        {
            try
            {
                mFtReader.ReaderClose();
                if (type == DK.FTREADER_TYPE_BT4)
                {
                    ShowMessage("BLE device has been disconnected.");
                }
                else if (type == DK.FTREADER_TYPE_USB)
                {
                    ShowMessage("USB device has been disconnected.");
                    addSpinnerPrivate(new String[] { });
                }
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
            }
        }

        public void CardReader_EscapeSend(String sendata)
        {
            try
            {
                ShowMessage("ESCAPE send : " + sendata);
                byte[] send = Utility.HexStrToBytes(sendata);

                long startTime = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds;
                byte[] data = mFtReader.ReaderEscape(slotIndex, send);
                long endTime = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds;

                ShowMessage("ESCAPE recv : " + Convection.Bytes2HexString(data) + " (" + (endTime - startTime) + "ms)");
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("ESCAPE failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_GetDeviceType()
        {
            try
            {
                int type = mFtReader.ReaderGetType();
                String result = "";
                switch (type)
                {
                    case 100:
                        result = "READER_R301";
                        break;
                    case 101:
                        result = "READER_BR301BLE";
                        break;
                    case 102:
                        result = "READER_BR500";
                        break;
                    case 103:
                        result = "READER_R502_CL";
                        break;
                    case 104:
                        result = "READER_R502_DUAL";
                        break;
                    case 105:
                        result = "READER_BR301";
                        break;
                    case 106:
                        result = "READER_IR301_LT";
                        break;
                    case 107:
                        result = "READER_IR301";
                        break;
                    case 108:
                        result = "READER_VR504";
                        break;
                    case 109:
                        result = "READER_R502_C9_U01";
                        break;
                    case 110:
                        result = "READER_R502_C9_U02";
                        break;
                    case 111:
                        result = "READER_R502_C9_U10";
                        break;
                    case 112:
                        result = "READER_R502_C9_U11";
                        break;
                    case 120:
                        result = "READER_UNKNOWN";
                        break;
                    default:
                        result = "READER_UNKNOWN";
                        break;
                }
                ShowMessage("type : " + result);
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Get device type failed.\n" + e.GetBaseException());
            };
        }

        public void CardReader_GetFirmVersion()
        {
            try
            {
                String version = mFtReader.ReaderGetFirmwareVersion();
                ShowMessage("Firmware version : " + version);
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Get firmware version failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_GetHardwareInfo()
        {
            try
            {
                byte[] hardwareinfo = mFtReader.ReaderGetHardwareInfo();
                ShowMessage("Hardwareinfo : " + Utility.Bytes2HexStr(hardwareinfo));
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Get hardware info failed.\n " + e.GetBaseException());
            }
        }

        public String CardReader_GetLibVersion()
        {
            String libVersion = FTReader.ReaderGetLibVersion();
            ShowMessage("Lib version : " + libVersion);
            return libVersion;
        }
        public void CardReader_GetBleFirmVersion()
        {
            try
            {
                String bleVersion = mFtReader.BleFirmwareVersion;
                Log.Error("lwk","获取到的蓝牙版本："+bleVersion);
                if (bleVersion == null || bleVersion.Equals(""))
                {
                    ShowMessage("Get bleVersion failed.");
                }
                else
                {
                    bleVersion = bleVersion.Substring(1, 1) + "." + bleVersion.Substring(3, 1) + "." + bleVersion.Substring(bleVersion.Length() - 2);
                    ShowMessage("getBleversion: " + bleVersion);
                }
            }
            catch (Exception e)
            {
                e.PrintStackTrace();
                ShowMessage("Get bleVersion failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_GetManufacturer()
        {
            try
            {
                byte[] manufacturer = mFtReader.ReaderGetManufacturer();
                ShowMessage("Manufacturer : " + System.Text.Encoding.Default.GetString(manufacturer));
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Get manufacturer failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_GetReaderName()
        {
            try
            {
                byte[] readername = mFtReader.ReaderGetReaderName();
                ShowMessage("Reader name : " + System.Text.Encoding.Default.GetString(readername));
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Get reader name failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_GetSlotstatus()
        {
            try
            {
                int status = mFtReader.ReaderGetSlotStatus(slotIndex);
                switch (status)
                {
                    case 0:
                        ShowMessage("SlotStatus: a card exists and is powered.");
                        break;
                    case 1:
                        ShowMessage("SlotStatus: a card exists but it is not powered.");
                        break;
                    case 2:
                        ShowMessage("SlotStatus: no cards exist.");
                        break;
                }
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Get slot status failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_GetSN()
        {
            try
            {
                byte[] sn = mFtReader.ReaderGetSerialNumber();
                ShowMessage("sn : " + Convection.Bytes2HexString(sn));
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Get sn failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_GetUid()
        {
            try
            {
                byte[] uid = mFtReader.ReaderGetUID();
                ShowMessage("Uid : " + Utility.Bytes2HexStr(uid));
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Get uid failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_PowerOFF()
        {
            try
            {
                mFtReader.ReaderPowerOff(slotIndex);
                ShowMessage("Power off success.");
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Power off failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_PowerOn()
        {
            try
            {
                byte[] atr = mFtReader.ReaderPowerOn(slotIndex);
                ShowMessage("Power on success. Atr : " + Convection.Bytes2HexString(atr));
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("Power on failed.\n" + e.GetBaseException());
            }
        }

        public void CardReader_XFRSend(String sendata)
        {
            try
            {
                ShowMessage("XFR send : " + sendata);
                byte[] send = Utility.HexStrToBytes(sendata);
                long startTime = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds;
                byte[] data = mFtReader.ReaderXfr(slotIndex, send);
                if (data[0] == 0x61)
                {
                    ShowMessage("XFR recv : " + Convection.Bytes2HexString(data));
                    ShowMessage("XFR send : 00C00000");
                    send = Utility.HexStrToBytes("00c00000" + StrUtil.Byte2HexStr((sbyte)data[1]));
                    data = mFtReader.ReaderXfr(slotIndex, send);
                }
                long endTime = (long)(DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalMilliseconds;
                ShowMessage("XFR recv : " + Convection.Bytes2HexString(data) + " (" + (endTime - startTime) + "ms)");
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
                ShowMessage("XFR failed:\n" + e.GetBaseException());
            }
        }

        public void ShowMessage(string msg)
        {
            myResultList.Add(msg);
            List<String> mResultList1 = new List<string> { };
            mResultList1.AddRange(myResultList);
            myResultListview.ItemsSource = mResultList1;
        }

        public void CardReader_Open(object obj)
        {
            try
            {
                for(int i = 0; i<myUSBNames.Length(); i++)
                {
                    if (obj.Equals(myUSBNames[i]))
                    {
                        mFtReader.ReaderOpen(myUSBNames[i]);
                    }
                }
            }
            catch (FTException e)
            {
                e.PrintStackTrace();
            }
        }

        public class MyHandler : Handler
        {
            private Action<Message> _action;//指向一个回调方法的委托

            [Obsolete]
            public MyHandler(Action<Message> action)
            {
                _action = action;//构造方法中传入处理消息的回调方法
            }
            //重写父类的HandleMessage方法
            public override void HandleMessage(Message msg)
            {
                _action?.Invoke(msg); //C#6.0新增判断空值的方式
            }
        }
    }
}