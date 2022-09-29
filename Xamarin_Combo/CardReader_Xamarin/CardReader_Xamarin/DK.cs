using System;
using System.Collections.Generic;
using System.Text;

namespace CardReader_Xamarin
{
    public class DK
    {
        public static readonly int USB_LOG = 16;
        public static readonly int USB_IN = 17;
        public static readonly int USB_OUT = 18;
        public static readonly int CARD_IN_MASK = 256;
        public static readonly int CARD_OUT_MASK = 512;
        public static readonly int CCIDSCHEME_LOG = 64;
        public static readonly int FTREADER_LOG = 80;
        public static readonly int PCSCSERVER_LOG = 96;
        public static readonly int BT3_LOG = 112;
        public static readonly int BT3_NEW = 113;
        public static readonly int BT3_DISCONNECTED = 114;
        public static readonly int BT4_LOG = 128;
        public static readonly int BT4_NEW = 129;
        public static readonly int BT4_ACL_DISCONNECTED = 130;
        public static readonly int FTREADER_TYPE_USB = 0;
        public static readonly int FTREADER_TYPE_BT3 = 1;
        public static readonly int FTREADER_TYPE_BT4 = 2;
        public static readonly int CARD_PRESENT_ACTIVE = 0;
        public static readonly int CARD_PRESENT_INACTIVE = 1;
        public static readonly int CARD_NO_PRESENT = 2;
        public static readonly int READER_R301E = 100;
        public static readonly int READER_BR301FC4 = 101;
        public static readonly int READER_BR500 = 102;
        public static readonly int READER_R502_CL = 103;
        public static readonly int READER_R502_DUAL = 104;
        public static readonly int READER_BR301 = 105;
        public static readonly int READER_IR301_LT = 106;
        public static readonly int READER_IR301 = 107;
        public static readonly int READER_VR504 = 108;
        public static readonly int READER_R502_C9_U01 = 109;
        public static readonly int READER_R502_C9_U02 = 110;
        public static readonly int READER_R502_C9_U10 = 111;
        public static readonly int READER_R502_C9_U11 = 112;
        public static readonly int READER_R502_C9_U12 = 113;
        public static readonly int READER_UNKNOWN = 120;
        public static readonly int BT4_CONNECTED = 0x83;

        public DK()
        {
        }
    }
}
