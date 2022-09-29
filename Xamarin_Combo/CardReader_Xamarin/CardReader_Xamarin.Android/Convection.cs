using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Java.IO;
using Java.Lang;
using Java.Math;
using Java.Util.Regex;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Boolean = Java.Lang.Boolean;
using Pattern = Java.Util.Regex.Pattern;
using String = System.String;

namespace CardReader_Xamarin.Droid
{
    internal class Convection
    {
        /**
	 * Decimal string to hexadecimal character for example"1610678288" ------>60010010
	 * **/
        public static String str10ToStr16(String str10)
        {
            return Long.ToHexString(Long.ParseLong(str10));
        }

        public static byte[] getUtf8Bytes(String str)
        {
            try
            {
                return System.Text.Encoding.Default.GetBytes(str);
            }
            catch (UnsupportedEncodingException uee)
            {
                return System.Text.Encoding.Default.GetBytes(str);
            }
        }

        public static byte[] hexString2Bytes(String hex)
        {
            return String2Bytes(hex, 16);
        }

        public static byte[] String2Bytes(String str)
        {
            return String2Bytes(str, 10);
        }

        private static byte[] String2Bytes(String str, int digit)
        {
            // Adding one byte to get the right conversion
            // values starting with "0" can be converted
            byte[] bArray = new BigInteger("10" + str, digit).ToByteArray();

            // Copy all the REAL bytes, not the "first"
            byte[] ret = new byte[bArray.Length - 1];
            for (int i = 0; i < ret.Length; i++)
            {
                ret[i] = bArray[i + 1];
            }

            return ret;
        }

        public static void printHexString(String hint, byte[] b)
        {
            // System.out.print(hint);

            for (int i = 0; i < b.Length; i++)
            {
                String hex = Integer.ToHexString(b[i] & 0xFF);

                if (hex.Length() == 1)
                {
                    hex = '0' + hex;
                }

                // System.out.print(hex.toUpperCase() + " ");
            }

            // System.out.println("");
        }

        public static String Bytes2HexString(byte[] b)
        {
            String ret = "";

            for (int i = 0; i < b.Length; i++)
            {
                String hex = Integer.ToHexString(b[i] & 0xFF);

                if (hex.Length() == 1)
                {
                    hex = '0' + hex;
                }

                ret += hex.ToUpper();
            }
            return ret;
        }

        public static String Bytes2HexString(byte[] b, int length)
        {
            String ret = "";

            for (int i = 0; i < length; i++)
            {
                String hex = Integer.ToHexString(b[i] & 0xFF);

                if (hex.Length() == 1)
                {
                    hex = '0' + hex;
                }

                ret += hex.ToUpper();
            }
            return ret;
        }

        public static String hexToString(String hex)
        {
            if (hex == null)
                return "";

            int length = hex.Length() & -2;

            StringBuffer result = new StringBuffer(length / 2);
            hexToString(hex, result);

            return result.ToString();
        }

        public static void hexToString(String hex, StringBuffer strbuf)
        {
            if (hex == null)
            {
                return;
            }
            
            int length = hex.Length() & -2;

            for (int pos = 0; pos < length; pos += 2)
            {
                int this_char = 0;
                try
                {
                    this_char = Integer.ParseInt(hex.Substring(pos, pos + 2), 16);
                }
                catch (NumberFormatException NF_Ex)
                {
                    /* dont care */

                }
                strbuf.Append((char)this_char);
            }
        }

        public static String stringToHex(String java)
        {
            if (java == null)
                return "";

            int length = java.Length();

            StringBuffer result = new StringBuffer(length * 2);
            stringToHex(java, result);

            return result.ToString();
        }

        public static void stringToHex(String java, StringBuffer strbuf)
        {
            if (java == null)
                return;

            int length = java.Length();

            for (int pos = 0; pos < length; pos++)
            {
                int this_char = java[pos];//对应java.chaAt(pos)

                for (int digit = 0; digit < 2; digit++)
                {
                    int this_digit = this_char & 0xf0;
                    this_char = this_char << 4;
                    this_digit = (this_digit >> 4);

                    if (this_digit >= 10)
                    {
                        strbuf.Append((char)(this_digit + 87));
                    }
                    else
                    {
                        strbuf.Append((char)(this_digit + 48));
                    }
                }
            }
        }

        public static int bytesToInt(byte[] bytes)
        {
            int mask = 0xff;
            int temp = 0;
            int res = 0;
            for (int i = 0; i < 4; i++)
            {
                res <<= 8;
                temp = bytes[i] & mask;
                res |= temp;
            }
            return res;
            /*
             * int num = 0; num += (bytes[0] << 24); num += (bytes[1] << 16); num +=
             * (bytes[2] << 8); num += bytes[3];
             * 
             * return num;
             */
        }

        public static int bytesToShort(byte[] bytes)
        {
            int mask = 0xff;
            int temp = 0;
            int res = 0;
            for (int i = 0; i < 2; i++)
            {
                res <<= 8;
                temp = bytes[i] & mask;
                res |= temp;
            }
            return res;
            /*
             * int num = 0; num += (bytes[0] << 24); num += (bytes[1] << 16); num +=
             * (bytes[2] << 8); num += bytes[3];
             * 
             * return num;
             */
        }

        public static byte[] htonl(int x)
        {
            byte[] res = new byte[4];

            for (int i = 0; i < 4; i++)
            {
                res[i] = (byte)(x >> 24);
                x <<= 8;
            }
            return res;
        }

        public static short makeWord(byte high, byte low)
        {
            short res;

            if (low >= 0)
            {
                res = (short)(high * 256 + low);
            }
            else
            {
                res = (short)(high * 256 + low + 256);
            }
            return res;
        }

        public static short getUnsignedValue(byte value)
        {
            if (value >= 0)
            {
                return value;
            }
            else
            {
                return (short)(value + 256);
            }
        }

        public static Boolean isValidValue(String value)
        {
            String strPinpattern = "^[0-9A-Fa-f]+$";
            Pattern pattern = Pattern.Compile(strPinpattern);
            Matcher matcher = pattern.Matcher(value);
            if (matcher.Find())
            {
                return (Boolean)true;
            }
            else
            {
                return (Boolean)false;
            }
        }

        public static String errorCode(int code)
        {
            return Bytes2HexString(htonl(code));
        }
    }
}