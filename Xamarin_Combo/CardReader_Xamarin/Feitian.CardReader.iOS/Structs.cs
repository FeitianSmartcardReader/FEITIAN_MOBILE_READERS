using System;
using System.Runtime.InteropServices;


namespace Feitian.CardReader.Library.iOS
{

    public enum Scope : uint
    {
        USER = 0x0000,
        TERMINAL = 0x0001,
        SYSTEM = 0x0002
    }

    public enum Protocol : uint
    {
        UNDEFINED = 0x0000,
        T0 = 0x0001,
        T1 = 0x0002,
        RAW = 0x0004,
        T15 = 0x0008
    }

    public enum Sharing : uint
    {
        EXCLUSIVE = 0x0001,
        SHARED = 0x0002,
        DIRECT = 0x0003
    }

    public enum Disposition : uint
    {
        LEAVE = 0x0000,
        RESET = 0x0001,
        UNPOWER = 0x0002,
        EJECT = 0x0003
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct SCARD_READERSTATE
    {
        public unsafe sbyte* szReader;

        public unsafe sbyte* pvUserData;

        public uint dwCurrentState;

        public uint dwEventState;

        public uint cbAtr;

        public uint isConnected;

        public byte[] rgbAtr;
    }

    [StructLayout(LayoutKind.Sequential)]

    public struct SCARD_IO_REQUEST
    {
        public uint dwProtocol;

        public uint cbPciLength;
    }

    public static class CFunctions
    {
        // extern LONG SCardEstablishContext (DWORD dwScope, LPCVOID pvReserved1, LPCVOID pvReserved2, LPSCARDCONTEXT phContext);
        [DllImport("__Internal")]
        public static extern unsafe int SCardEstablishContext(uint dwScope, void* pvReserved1, void* pvReserved2, int* phContext);

        // extern LONG SCardReleaseContext (SCARDCONTEXT hContext);
        [DllImport("__Internal")]
        public static extern int SCardReleaseContext(int hContext);

        // extern LONG SCardIsValidContext (SCARDCONTEXT hContext);
        [DllImport("__Internal")]
        public static extern int SCardIsValidContext(int hContext);

        // extern LONG SCardConnect (SCARDCONTEXT hContext, LPCSTR szReader, DWORD dwShareMode, DWORD dwPreferredProtocols, LPSCARDHANDLE phCard, LPDWORD pdwActiveProtocol);
        [DllImport("__Internal")]
        public static extern unsafe int SCardConnect(int hContext, sbyte* szReader, uint dwShareMode, uint dwPreferredProtocols, int* phCard, uint* pdwActiveProtocol);

        // extern LONG SCardDisconnect (SCARDHANDLE hCard, DWORD dwDisposition);
        [DllImport("__Internal")]
        public static extern int SCardDisconnect(int hCard, uint dwDisposition);

        // extern LONG SCardBeginTransaction (SCARDHANDLE hCard);
        [DllImport("__Internal")]
        public static extern int SCardBeginTransaction(int hCard);

        // extern LONG SCardEndTransaction (SCARDHANDLE hCard, DWORD dwDisposition);
        [DllImport("__Internal")]
        public static extern int SCardEndTransaction(int hCard, uint dwDisposition);

        // extern LONG SCardStatus (SCARDHANDLE hCard, LPSTR mszReaderName, LPDWORD pcchReaderLen, LPDWORD pdwState, LPDWORD pdwProtocol, LPBYTE pbAtr, LPDWORD pcbAtrLen);
        [DllImport("__Internal")]
        public static extern unsafe int SCardStatus(int hCard, sbyte* mszReaderName, uint* pcchReaderLen, uint* pdwState, uint* pdwProtocol, byte* pbAtr, uint* pcbAtrLen);

        // extern LONG SCardGetStatusChange (SCARDCONTEXT hContext, DWORD dwTimeout, LPSCARD_READERSTATE rgReaderStates, DWORD cReaders);
        [DllImport("__Internal")]
        public static extern unsafe int SCardGetStatusChange(int hContext, uint dwTimeout, SCARD_READERSTATE rgReaderStates, uint cReaders);

        // extern LONG SCardControl (SCARDHANDLE hCard, DWORD dwControlCode, LPCVOID pbSendBuffer, DWORD cbSendLength, LPVOID pbRecvBuffer, DWORD cbRecvLength, LPDWORD lpBytesReturned);
        [DllImport("__Internal")]
        public static extern unsafe int SCardControl(int hCard, uint dwControlCode, void* pbSendBuffer, uint cbSendLength, void* pbRecvBuffer, uint cbRecvLength, uint* lpBytesReturned);

        // extern LONG SCardTransmit (SCARDHANDLE hCard, const SCARD_IO_REQUEST *pioSendPci, LPCBYTE pbSendBuffer, DWORD cbSendLength, SCARD_IO_REQUEST *pioRecvPci, LPBYTE pbRecvBuffer, LPDWORD pcbRecvLength);
        [DllImport("__Internal")]
        public static extern unsafe int SCardTransmit(int hCard, SCARD_IO_REQUEST* pioSendPci, byte* pbSendBuffer, uint cbSendLength, SCARD_IO_REQUEST* pioRecvPci, byte* pbRecvBuffer, uint* pcbRecvLength);

        // extern LONG SCardListReaderGroups (SCARDCONTEXT hContext, LPSTR mszGroups, LPDWORD pcchGroups);
        [DllImport("__Internal")]
        public static extern unsafe int SCardListReaderGroups(int hContext, sbyte* mszGroups, uint* pcchGroups);

        // extern LONG SCardListReaders (SCARDCONTEXT hContext, LPCSTR mszGroups, LPSTR mszReaders, LPDWORD pcchReaders);
        [DllImport("__Internal")]
        public static extern unsafe int SCardListReaders(int hContext, sbyte* mszGroups, sbyte* mszReaders, uint* pcchReaders);

        // extern LONG SCardCancel (SCARDCONTEXT hContext);
        [DllImport("__Internal")]
        public static extern int SCardCancel(int hContext);

        // extern LONG SCardReconnect (SCARDHANDLE hCard, DWORD dwShareMode, DWORD dwPreferredProtocols, DWORD dwInitialization, LPDWORD pdwActiveProtocol);
        [DllImport("__Internal")]
        public static extern unsafe int SCardReconnect(int hCard, uint dwShareMode, uint dwPreferredProtocols, uint dwInitialization, uint* pdwActiveProtocol);

        // extern LONG SCardGetAttrib (SCARDHANDLE hCard, DWORD dwAttrId, LPBYTE pbAttr, LPDWORD pcbAttrLen);
        [DllImport("__Internal")]
        public static extern unsafe int SCardGetAttrib(int hCard, uint dwAttrId, byte* pbAttr, uint* pcbAttrLen);

        // extern LONG SCARD_CTL_CODE (unsigned int code);
        [DllImport("__Internal")]
        public static extern int SCARD_CTL_CODE(uint code);

        // extern LONG FtGetSerialNum (SCARDHANDLE hCard, unsigned int length, char *buffer);
        [DllImport("__Internal")]
        public static extern unsafe int FtGetSerialNum(int hCard, uint* length, sbyte* buffer);

        // extern LONG FtWriteFlash (SCARDHANDLE hCard, unsigned char bOffset, unsigned char blength, unsigned char *buffer);
        [DllImport("__Internal")]
        public static extern int FtWriteFlash(int hCard, byte bOffset, byte blength, byte[] buffer);

        // extern LONG FtReadFlash (SCARDHANDLE hCard, unsigned char bOffset, unsigned char blength, unsigned char *buffer);
        [DllImport("__Internal")]
        public static extern int FtReadFlash(int hCard, byte bOffset, byte blength, byte[] buffer);

        // extern LONG FtSetTimeout (SCARDCONTEXT hContext, DWORD dwTimeout);
        [DllImport("__Internal")]
        public static extern int FtSetTimeout(int hContext, uint dwTimeout);

        // extern LONG FtDukptInit (SCARDHANDLE hCard, unsigned char *encBuf, unsigned int nLen);
        [DllImport("__Internal")]
        public static extern unsafe int FtDukptInit(int hCard, byte* encBuf, uint nLen);

        // extern LONG FtDukptSetEncMod (SCARDHANDLE hCard, unsigned int bEncrypt, unsigned int bEncFunc, unsigned int bEncType);
        [DllImport("__Internal")]
        public static extern int FtDukptSetEncMod(int hCard, uint bEncrypt, uint bEncFunc, uint bEncType);

        // extern LONG FtDukptGetKSN (SCARDHANDLE hCard, unsigned int *pnlength, unsigned char *buffer);
        [DllImport("__Internal")]
        public static extern unsafe int FtDukptGetKSN(int hCard, uint* pnlength, byte* buffer);

        // extern void FtDidEnterBackground (unsigned int bDidEnter);
        [DllImport("__Internal")]
        public static extern void FtDidEnterBackground(uint bDidEnter);

        // extern LONG FtSle4442Cmd (SCARDHANDLE hCard, LPCBYTE pbCmd, DWORD bLengthToRead, BYTE bIsClockNum, LPBYTE pbRecvBuffer, LPDWORD pcbRecvLength);
        //[DllImport("__Internal")]
        //public static extern unsafe int FtSle4442Cmd(int hCard, byte* pbCmd, uint bLengthToRead, byte bIsClockNum, byte* pbRecvBuffer, uint* pcbRecvLength);

        // extern void FtGetLibVersion (char *buffer);
        [DllImport("__Internal")]
        public static extern unsafe void FtGetLibVersion(sbyte* buffer);

        // extern LONG FtGetDevVer (SCARDCONTEXT hContext, char *firmwareRevision, char *hardwareRevision);
        [DllImport("__Internal")]
        public static extern unsafe int FtGetDevVer(int hContext, sbyte* firmwareRevision, sbyte* hardwareRevision);

        // extern LONG FtGetCurrentReaderType (unsigned int *readerType);
        [DllImport("__Internal")]
        public static extern unsafe int FtGetCurrentReaderType(uint* readerType);

        [DllImport("__Internal")]
        public static extern unsafe int FtGetDeviceUID(int hCard, uint *length, sbyte* buffer);

        [DllImport("__Internal")]
        public static extern unsafe int FtGetReaderName(int hCard, uint* length, sbyte* buffer);
        [DllImport("__Internal")]
        public static extern unsafe int FtGetAccessoryManufacturer(int hCard, uint* length, sbyte* buffer);
        [DllImport("__Internal")]
        public static extern unsafe int FT_AutoTurnOffReader(bool isOpen);

        [DllImport("__Internal")]
        public static extern unsafe int FTGetBluetoothFWVer(int hCard,sbyte*buffer);

    }

    public enum Readertype : uint
    {
        Unkown = 0,
        bR301,
        iR301U_DOCK,
        iR301U_LIGHTING,
        READER_bR301, //bR301 B55
        READER_bR301B, //bR301 C63
        READER_bR301BLE,
        READER_bR500
    }
    public enum FTDEVICETYPE : uint
    {
        EMPTY_DEVICE = 0,
        IR301_AND_BR301 = 1,
        BR301BLE_AND_BR500 = 2,
    }
}


