using CardReader_Xamarin.iOS;
using System;
using System.Collections.Generic;
using Xamarin.Forms;
using Feitian.CardReader.Library.iOS;
using ObjCRuntime;
using System.Runtime.InteropServices;
using Serilog;

[assembly: Xamarin.Forms.Dependency(typeof(CardReaderInterfaceImpl))]


namespace CardReader_Xamarin.iOS
{
    class CardReaderInterfaceImpl : CardReaderInterface
    {
        Xamarin.Forms.Picker picker_USBReaderName;
        Xamarin.Forms.ListView myResultListview;
        List<string> myResultList, myUSBNames;

        SubReaderInterfaceDelegate selector;
        int gContxtHandle;
        int gCardHandle;
        public string cardreadername;
        ReaderInterface interf;


        public void CardReader_Init(int FTREADER_TYPE, Xamarin.Forms.ListView myListview, List<string> mResultList, Xamarin.Forms.Picker picker)
        {
            myResultListview = myListview;
            myResultListview.VerticalOptions = LayoutOptions.FillAndExpand;
            myResultListview.HasUnevenRows = true;
            myResultList = mResultList;
            picker_USBReaderName = picker;
            myUSBNames = new List<string>();

            interf = new ReaderInterface();
            interf.setAutoPair(true);

            Log.Error("lwk", "1111111111111111");
            selector = new SubReaderInterfaceDelegate(this);

            interf.SetDelegate(selector);

            //if (gContxtHandle == 0)
            //{


            //    Test();


            //}

        }
        public unsafe void Test()
        {



            fixed (int* ptr = &gContxtHandle)
            {
                Console.WriteLine("000-----------------");
                int ret = CFunctions.SCardEstablishContext((uint)Scope.SYSTEM, null, null, ptr);

                if (ret != 0)
                {
                    Console.WriteLine("0-----------------");
                    Console.WriteLine(ret);

                    Console.WriteLine("{0:X}", ret);
                    Console.WriteLine("1-----------------");
                    ShowMessage("Initialization failed.");
                    return;
                }
                else
                {
                    ShowMessage("Initialization succeeded.");
                    Console.WriteLine("Initialization succeeded.-----------------");
                    CFunctions.FtSetTimeout(gContxtHandle, 50000);
                }
            }

        }


        public void CardReader_Find(int type)
        {
            ShowMessage("CardReader_Find");

            Test();


        }

        public void CardReader_AutoTurnOff(bool isOpen)
        {


            int ret = CFunctions.FT_AutoTurnOffReader(isOpen);
            if (ret == 0)
            {
                ShowMessage("AutoTurnOffsetting-success");
            }
            else
            {
                ShowMessage("AutoTurnOffsetting-fail");
            }

        }
        public void CardReader_Close()
        {
            ShowMessage("CardReader_Close");

            int ret = CFunctions.SCardReleaseContext(gContxtHandle);
            if (ret == 0)
            {

            }
            else
            {

            }
        }

        public void CardReader_EscapeSend(String sendata)
        {


            unsafe
            {

                SCARD_IO_REQUEST pioSendPci;

                byte[] dataarray = StrToHexByte(sendata);



                uint slen = (uint)dataarray.Length;


                byte* bp = (byte*)Marshal.AllocHGlobal(dataarray.Length);

                Marshal.Copy(dataarray, 0, (IntPtr)bp, (int)slen);



                SCARD_IO_REQUEST* pioS = &pioSendPci;
                byte* rsendbf = (byte*)Marshal.AllocHGlobal(2176);
                uint rlen = 2176;
                //uint* rslen = &rlen;

                uint dwControlCode = 3549;

                uint DReturn = 0;
                uint* dreturn = &DReturn;



                int ret = CFunctions.SCardControl(gCardHandle, dwControlCode, bp, slen, rsendbf, rlen, dreturn);
                if (ret == 0)
                {

                    string ssf = "";
                    Console.WriteLine(DReturn);

                    for (int i = 0; i < DReturn; ++i)
                    {
                        string s2 = rsendbf[i].ToString("x2");
                        ssf = ssf + s2;

                    }

                    ssf = "<" + ssf + ">";
                    Console.WriteLine(ssf);
                    ShowMessage("escapeback-data->" + ssf);

                }
                else
                {
                    Console.WriteLine("{0:X}", ret);
                    ShowMessage("escapeback----fail");

                }

                Marshal.FreeHGlobal((IntPtr)bp);
                Marshal.FreeHGlobal((IntPtr)rsendbf);

            }



        }

        public void CardReader_GetDeviceType()
        {

            unsafe
            {
                uint type = 0;
                uint* ttpe = &type;

                int ret = CFunctions.FtGetCurrentReaderType(ttpe);
                if (type == 1)
                {
                    ShowMessage("reader-type-" + "READER_iR301U_DOCK");
                }
                else if (type == 2)
                {
                    ShowMessage("reader-type-" + "READER_iR301U_LIGHTING");
                }
                else if (type == 3)
                {
                    ShowMessage("reader-type-" + "READER_bR301");
                }
                else if (type == 4)
                {
                    ShowMessage("reader-type-" + "READER_bR301B");
                }
                else if (type == 5)
                {
                    ShowMessage("reader-type-" + "READER_bR301BLE");
                }
                else if (type == 6)
                {
                    ShowMessage("reader-type-" + "READER_bR500");
                }
                else
                {
                    ShowMessage("reader-type-" + "READER_UNKOWN");
                }


            }


        }

        public void CardReader_GetFirmVersion()
        {


            unsafe
            {
                IntPtr intPtrStr1 = (IntPtr)Marshal.AllocHGlobal(32);
                sbyte* sbyteStr1 = (sbyte*)intPtrStr1;

                IntPtr intPtrStr2 = (IntPtr)Marshal.AllocHGlobal(32);
                sbyte* sbyteStr2 = (sbyte*)intPtrStr2;

                int ret = CFunctions.FtGetDevVer(gContxtHandle, sbyteStr1, sbyteStr2);
                if (ret == 0)
                {
                    string fsversion = new string(sbyteStr1);
                    //string hsversion = new string(sbyteStr2);
                    ShowMessage("firmversion-" + fsversion);
                    //ShowMessage("hardversion-" + hsversion);
                }
                else
                {
                    ShowMessage("readergetfirmversion--fail");
                }

                Marshal.FreeHGlobal((IntPtr)intPtrStr1);
                Marshal.FreeHGlobal((IntPtr)intPtrStr2);


            }
        }

        public void CardReader_GetHardwareInfo()
        {
            ShowMessage("CardReader_GetHardwareInfo");

        }

        public String CardReader_GetLibVersion()
        {

            unsafe
            {
                IntPtr intPtrStr = (IntPtr)Marshal.AllocHGlobal(25);

                sbyte* sbyteStr1 = (sbyte*)intPtrStr;

                CFunctions.FtGetLibVersion(sbyteStr1);

                string sversion = new string(sbyteStr1);

                ShowMessage("libVersion--->" + sversion);

                Marshal.FreeHGlobal((IntPtr)intPtrStr);

            }


            return null;
        }
        public void CardReader_GetBleFirmVersion()
        {


            unsafe
            {
                IntPtr intPtrStr = (IntPtr)Marshal.AllocHGlobal(10);

                sbyte* sbyteStr1 = (sbyte*)intPtrStr;
                int ret = CFunctions.FTGetBluetoothFWVer(gContxtHandle, sbyteStr1);
                if (ret == 0)
                {
                    string bleversion = new string(sbyteStr1);
                    ShowMessage("bleversion" + bleversion);

                }

                Marshal.FreeHGlobal((IntPtr)intPtrStr);
            }
        }



        public void CardReader_GetManufacturer()
        {

            unsafe
            {
                IntPtr intPtrStr = (IntPtr)Marshal.AllocHGlobal(25);

                sbyte* sbyteStr1 = (sbyte*)intPtrStr;


                uint len = 25;
                uint* slen = &len;

                int ret = CFunctions.FtGetAccessoryManufacturer(gCardHandle, slen, sbyteStr1);
                if (ret == 0)
                {

                    string ssf = new string(sbyteStr1);

                    Console.WriteLine(ssf);
                    ShowMessage(ssf);
                }
                else
                {
                    string ssff = "getmanfacturer-->fail";
                    ShowMessage(ssff);

                }

                Marshal.FreeHGlobal((IntPtr)intPtrStr);

            }


        }

        public void CardReader_GetReaderName()
        {

            unsafe
            {
                IntPtr intPtrStr = (IntPtr)Marshal.AllocHGlobal(25);
                sbyte* sbyteStr1 = (sbyte*)intPtrStr;


                uint len = 25;
                uint* slen = &len;
                int ret = CFunctions.FtGetReaderName(gCardHandle, slen, sbyteStr1);
                if (ret == 0)
                {

                    string ssf = new string(sbyteStr1);

                    ShowMessage(ssf);
                }
                else
                {
                    string ssff = "getreadername-->fail";
                    ShowMessage(ssff);

                }
                Marshal.FreeHGlobal((IntPtr)intPtrStr);

            }
        }

        public void CardReader_GetSlotstatus()
        {
            ShowMessage("CardReader_GetSlotstatus");

            unsafe
            {

                //SCARD_READERSTATE rs = new SCARD_READERSTATE();

                //IntPtr intPtrStr = (IntPtr)Marshal.StringToHGlobalAnsi(cardreadername);

                //sbyte* sbyteStr1 = (sbyte*)intPtrStr;

                //rs.szReader = sbyteStr1;
                //rs.dwCurrentState = (uint)Feitian.CardReader.Library.iOS.Protocol.UNDEFINED;
                //rs.cbAtr = 0;
                //rs.dwEventState = 0x000;
                //rs.pvUserData = null;

                //uint INFININE = 0xFFFFFFFF;


                //int ret = CFunctions.SCardGetStatusChange(gCardHandle,INFININE,rs,1);
                //if(ret==0)
                //{
                //    if((rs.dwCurrentState & 0x0020) != 0)
                //    {
                //        ShowMessage("have---card");
                //    }
                //    else
                //    {
                //        ShowMessage("no---card");
                //    }
                //}else
                //{
                //    ShowMessage("findcardslot---fail");
                //}


                bool iscardattached = interf.IsCardAttached;
                if (iscardattached)
                {
                    ShowMessage("have---card");
                }
                else
                {
                    ShowMessage("no---card");
                }
            }


        }

        public void CardReader_GetSN()
        {

            unsafe
            {
                IntPtr intPtrStr = (IntPtr)Marshal.AllocHGlobal(16);
                sbyte* sbyteStr1 = (sbyte*)intPtrStr;

                uint len = 0;
                uint* slen = &len;
                int ret = CFunctions.FtGetSerialNum(gCardHandle, slen, sbyteStr1);

                if (ret == 0)
                {
                    string ssf = "";
                    for (int i = 0; i < len; ++i)
                    {
                        string s2 = sbyteStr1[i].ToString("x2");
                        ssf = ssf + s2;

                    }
                    ssf = "getserinum-->" + "<" + ssf + ">";
                    Console.WriteLine(ssf);
                    ShowMessage(ssf);

                }
                else
                {
                    ShowMessage("getserinum-fail");
                }

                Marshal.FreeHGlobal((IntPtr)intPtrStr);
            }
        }


        public void CardReader_GetUid()
        {

            unsafe
            {

                IntPtr intPtrStr = (IntPtr)Marshal.AllocHGlobal(20);

                sbyte* sbyteStr1 = (sbyte*)intPtrStr;


                uint len = 20;
                uint* slen = &len;

                int ret = CFunctions.FtGetDeviceUID(gCardHandle, slen, sbyteStr1);
                if (ret == 0)
                {

                    string ssf = "";
                    for (int i = 0; i < len; ++i)
                    {
                        string s2 = sbyteStr1[i].ToString("x2");
                        ssf = ssf + s2;

                    }
                    ssf = "get--uid-->" + "<" + ssf + ">";
                    Console.WriteLine(ssf);
                    ShowMessage(ssf);
                }
                else
                {
                    string ssff = "get--uid-->fail";
                    ShowMessage(ssff);

                }

                Marshal.FreeHGlobal((IntPtr)intPtrStr);

            }


        }

        public void CardReader_PowerOFF()
        {



            int ret = CFunctions.SCardDisconnect(gCardHandle, (uint)Disposition.UNPOWER);
            if (ret == 0)
            {
                ShowMessage("CardReader_PowerOFF-success");
            }
            else
            {
                ShowMessage("CardReader_PowerOFF-fail");
            }
        }

        public void CardReader_PowerOn()
        {
            unsafe
            {
                IntPtr intPtrStr = (IntPtr)Marshal.StringToHGlobalAnsi(cardreadername);

                sbyte* sbyteStr1 = (sbyte*)intPtrStr;


                uint dwActiveProtocol;


                fixed (int* ptrcard = &gCardHandle)
                {


                    uint* dwptr = &dwActiveProtocol;

                    int ret = CFunctions.SCardConnect(gContxtHandle, sbyteStr1, (uint)Sharing.SHARED, (uint)(Feitian.CardReader.Library.iOS.Protocol.T0 | Feitian.CardReader.Library.iOS.Protocol.T1), ptrcard, dwptr);

                    if (ret == 0)
                    {
                        ShowMessage("CardReader_PowerOn----success");

                        byte* bp = (byte*)Marshal.AllocHGlobal(33);

                        uint len = 33;
                        uint* slen = &len;



                        int ret1 = CFunctions.SCardGetAttrib(gCardHandle, 0, bp, slen);

                        if (ret1 == 0)
                        {

                            Console.WriteLine(len);


                            string ssf = "";
                            for (int i = 0; i < len; ++i)
                            {
                                string s2 = bp[i].ToString("x2");
                                ssf = ssf + s2;

                            }
                            ssf = "get--atr-->" + ssf;
                            Console.WriteLine(ssf);
                            ShowMessage(ssf);


                        }
                        else
                        {
                            Console.WriteLine("-------===========---------");
                            Console.WriteLine("{0:X}", ret1);

                            ShowMessage("CardReader_getATR----fail");
                        }

                        Marshal.FreeHGlobal((IntPtr)bp);

                    }
                    else
                    {
                        ShowMessage("CardReader_PowerOn----fail");
                    }
                }

                Marshal.FreeHGlobal((IntPtr)intPtrStr);
            }

        }

        public void CardReader_XFRSend(String sendata)
        {

            unsafe
            {

                SCARD_IO_REQUEST pioSendPci;
                //byte[] dataarray = System.Text.Encoding.Default.GetBytes(sendata);
                byte[] dataarray = StrToHexByte(sendata);



                uint slen = (uint)dataarray.Length;


                byte* bp = (byte*)Marshal.AllocHGlobal(dataarray.Length);

                Marshal.Copy(dataarray, 0, (IntPtr)bp, (int)slen);



                SCARD_IO_REQUEST* pioS = &pioSendPci;
                byte* rsendbf = (byte*)Marshal.AllocHGlobal(2176);
                uint rlen = 2176;
                uint* rslen = &rlen;


                int ret = CFunctions.SCardTransmit(gCardHandle, pioS, bp, slen, null, rsendbf, rslen);
                if (ret == 0)
                {

                    string ssf = "";
                    Console.WriteLine(rlen);

                    for (int i = 0; i < rlen; ++i)
                    {
                        string s2 = rsendbf[i].ToString("x2");
                        ssf = ssf + s2;

                    }

                    ssf = "<" + ssf + ">";
                    Console.WriteLine(ssf);
                    ShowMessage("cardback-data->" + ssf);

                }
                else
                {
                    Console.WriteLine("{0:X}", ret);
                    ShowMessage("Cardback----fail");

                }

                Marshal.FreeHGlobal((IntPtr)bp);

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
            ShowMessage("CardReader_Open");
        }


        public static byte[] StrToHexByte(string hexString)
        {
            hexString = hexString.Replace(" ", "");
            if ((hexString.Length % 2) != 0)
                hexString += " ";
            byte[] returnBytes = new byte[hexString.Length / 2];
            for (int i = 0; i < returnBytes.Length; i++)
                returnBytes[i] = Convert.ToByte(hexString.Substring(i * 2, 2), 16);
            return returnBytes;
        }
    }
}