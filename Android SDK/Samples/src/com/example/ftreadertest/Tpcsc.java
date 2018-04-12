package com.example.ftreadertest;

import com.ftsafe.DK;

import android.os.Handler;

public class Tpcsc {


	public native void testA(int port);
	
	static{
		System.loadLibrary("FTReaderTest");
	}
}
