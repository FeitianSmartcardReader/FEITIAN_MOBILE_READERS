package com.ftsafe.cardreader.utils;

import android.content.Context;
import android.content.SharedPreferences;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Convection {

	/**
	 * Decimal string to hexadecimal character for example"1610678288" ------>60010010
	 * **/
	public static String str10ToStr16(String str10) {
		return Long.toHexString(Long.parseLong(str10));
	}

	public static byte[] getUtf8Bytes(String str) {
		try {
			return str.getBytes("UTF-8");
		} catch (UnsupportedEncodingException uee) {
			return str.getBytes();
		}
	}

	public static byte[] hexString2Bytes(String hex) {
		return String2Bytes(hex, 16);
	}

	public static byte[] String2Bytes(String str) {
		return String2Bytes(str, 10);
	}

	private static byte[] String2Bytes(String str, int digit) {
		// Adding one byte to get the right conversion
		// values starting with "0" can be converted
		byte[] bArray = new BigInteger("10" + str, digit).toByteArray();

		// Copy all the REAL bytes, not the "first"
		byte[] ret = new byte[bArray.length - 1];
		for (int i = 0; i < ret.length; i++) {
			ret[i] = bArray[i + 1];
		}

		return ret;
	}

	public static void printHexString(String hint, byte[] b) {
		// System.out.print(hint);

		for (int i = 0; i < b.length; i++) {
			String hex = Integer.toHexString(b[i] & 0xFF);

			if (hex.length() == 1) {
				hex = '0' + hex;
			}

			// System.out.print(hex.toUpperCase() + " ");
		}

		// System.out.println("");
	}

	public static String Bytes2HexString(byte[] b) {
		String ret = "";

		for (int i = 0; i < b.length; i++) {
			String hex = Integer.toHexString(b[i] & 0xFF);

			if (hex.length() == 1) {
				hex = '0' + hex;
			}

			ret += hex.toUpperCase();
		}
		return ret;
	}

	/**
	 * Hexadecimal to Ascii code
	 * @param hex
	 * @return
	 */
	public static String convertHexToString(String hex) {
		StringBuilder sb = new StringBuilder();
		StringBuilder temp = new StringBuilder();
		for (int i = 0; i < hex.length() - 1; i += 2) {
			String output = hex.substring(i, (i + 2));
			int decimal = Integer.parseInt(output, 16);
			sb.append((char) decimal);
			temp.append(decimal);
		}
		return sb.toString();
	}

	/**
	 * Ascii code to hexadecimal
	 * @param str
	 * @return
	 */
	public static String convertStringToHex(String str){
		char[] chars = str.toCharArray();
		StringBuffer hex = new StringBuffer();
		for(int i = 0; i < chars.length; i++){
			hex.append(Integer.toHexString((int)chars[i]));
		}
		return hex.toString();
	}

	public static String Bytes2HexString(byte[] b, int length) {
		String ret = "";

		for (int i = 0; i < length; i++) {
			String hex = Integer.toHexString(b[i] & 0xFF);

			if (hex.length() == 1) {
				hex = '0' + hex;
			}

			ret += hex.toUpperCase();
		}
		return ret;
	}

	public static final String hexToString(String hex) {
		if (hex == null)
			return "";

		int length = hex.length() & -2;

		StringBuffer result = new StringBuffer(length / 2);
		hexToString(hex, result);

		return result.toString();
	}

	public static final void hexToString(String hex, StringBuffer out) {
		if (hex == null)
			return;

		int length = hex.length() & -2;

		for (int pos = 0; pos < length; pos += 2) {
			int this_char = 0;
			try {
				this_char = Integer.parseInt(hex.substring(pos, pos + 2), 16);
			} catch (NumberFormatException NF_Ex) {
				/* dont care */

			}
			out.append((char) this_char);
		}
	}

	public static final String stringToHex(String java) {
		if (java == null)
			return "";

		int length = java.length();

		StringBuffer result = new StringBuffer(length * 2);
		stringToHex(java, result);

		return result.toString();
	}

	public static final void stringToHex(String java, StringBuffer out) {
		if (java == null)
			return;

		int length = java.length();

		for (int pos = 0; pos < length; pos++) {
			int this_char = java.charAt(pos);

			for (int digit = 0; digit < 2; digit++) {
				int this_digit = this_char & 0xf0;
				this_char = this_char << 4;
				this_digit = (this_digit >> 4);

				if (this_digit >= 10) {
					out.append((char) (this_digit + 87));
				} else {
					out.append((char) (this_digit + 48));
				}
			}
		}
	}

	public static int bytesToInt(byte[] bytes) {
		int mask = 0xff;
		int temp = 0;
		int res = 0;
		for (int i = 0; i < 4; i++) {
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

	public static int bytesToShort(byte[] bytes) {
		int mask = 0xff;
		int temp = 0;
		int res = 0;
		for (int i = 0; i < 2; i++) {
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

	public static byte[] htonl(int x) {
		byte[] res = new byte[4];

		for (int i = 0; i < 4; i++) {
			res[i] = (byte) (x >> 24);
			x <<= 8;
		}
		return res;
	}

	public static short makeWord(byte high, byte low) {
		short res;

		if (low >= 0) {
			res = (short) (high * 256 + low);
		} else {
			res = (short) (high * 256 + low + 256);
		}
		return res;
	}

	public static short getUnsignedValue(byte value) {
		if (value >= 0) {
			return value;
		} else {
			return (short) (value + 256);
		}
	}

	public static boolean isValidValue(String value) {
		String strPinpattern = "^[0-9A-Fa-f]+$";
		Pattern pattern = Pattern.compile(strPinpattern);
		Matcher matcher = pattern.matcher(value);
		if (matcher.find()) {
			return true;
		} else {
			return false;
		}
	}

	public static void setIsAutoConnect(Context context,Boolean isAutoConnect){
		SharedPreferences settings = context.getSharedPreferences("TestXML", 0);
		SharedPreferences.Editor localEditor = settings.edit();
		localEditor.putBoolean("AutoConnect", isAutoConnect);
		localEditor.commit();
	}

	public static Boolean getIsAutoConnect(Context context){
		Boolean isAutoConnect = false;
		SharedPreferences settings = context.getSharedPreferences("TestXML", 0);
		isAutoConnect = settings.getBoolean("AutoConnect", false);
		return isAutoConnect;
	}

	public static void setIsAutoTurnOff(Context context,Boolean isAutoConnect){
		SharedPreferences settings = context.getSharedPreferences("TestXML1", 0);
		SharedPreferences.Editor localEditor = settings.edit();
		localEditor.putBoolean("AutoTurnOff", isAutoConnect);
		localEditor.commit();
	}

	public static Boolean getIsAutoTurnOff(Context context){
		Boolean isAutoConnect = false;
		SharedPreferences settings = context.getSharedPreferences("TestXML1", 0);
		isAutoConnect = settings.getBoolean("AutoTurnOff", false);
		return isAutoConnect;
	}

	public static String errorCode(int code) {
		return Bytes2HexString(htonl(code));
	}
}
