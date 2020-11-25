package com.ftsafe.pcscdemo;

public class PCSCNative {
    static{
        System.loadLibrary("pcsc");
    }

    public static native void FT_Init();
    public static native void FT_UnInit();
    public static native int SCardEstablishContext();
    public static native int SCardReleaseContext();
    public static native int SCardIsValidContext();
    public static native int SCardListReaderGroups();
    public static native int SCardListReaders(byte[] readerNames);
    public static native int SCardConnect(byte[] readerName);
    public static native int SCardDisconnect();
    public static native int SCardBeginTransaction();
    public static native int SCardEndTransaction();
    public static native int SCardStatus(int[] cardState, int[] protocol, byte[] atr, int[] atrLen);
    public static native int SCardGetStatusChange(int[] cardState, byte[] atr, int[] atrLen);
    public static native int SCardControl(byte[] send, byte[] recv, int[] recvLen);
    public static native int SCardTransmit(byte[] send, byte[] recv, int[] recvLen);
    public static native int SCardCancel();
    public static native int SCardReconnect();
    public static native int SCardGetAttrib(byte[] atr, int[] atrLen);
}
