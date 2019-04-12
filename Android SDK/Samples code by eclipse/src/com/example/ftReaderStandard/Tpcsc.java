package com.example.ftReaderStandard;

import com.ftsafe.DK;

import android.os.Handler;

public class Tpcsc {
	
//	public Tpcsc(){
//		
//	}
	public Tpcsc(int port){
		init(port);
	}
	
	
	public native void init(int port);
	public native int SCardEstablishContext();
	public native String SCardListReaders();
	public native int SCardConnect(int index);
	public native byte[] SCardStatus();
	public native byte[] SCardTransmit(byte[] apdu,int apdulen);
	public native byte[] SCardControl(byte[] apdu,int apdulen);
	public native int SCardDisconnect();
	public native int SCardReleaseContext();
	
	public native int SCardIsValidContext();
	public native int SCardGetStatusChange(int index);
	
	public native String SCardGetLastError();
	static{
		System.loadLibrary("FTReaderStandard");
	}
}
