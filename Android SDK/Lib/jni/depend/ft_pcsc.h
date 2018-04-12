#ifndef __FT_PCSC_H__
#define __FT_PCSC_H__


typedef unsigned long DWORD;
typedef unsigned long ULONG;


typedef const void *LPCVOID;
typedef ULONG SCARDCONTEXT;
//typedef SCARDCONTEXT *PSCARDCONTEXT;
typedef SCARDCONTEXT *LPSCARDCONTEXT;

typedef const char *LPCSTR;
typedef char *LPSTR;
typedef DWORD *LPDWORD;
typedef unsigned char *LPBYTE;
typedef const unsigned char *LPCBYTE;

typedef void *LPVOID;



typedef ULONG SCARDHANDLE;
typedef SCARDHANDLE *LPSCARDHANDLE;


typedef struct{
	unsigned long dwProtocol;
	unsigned long cbPciLength;
}SCARD_IO_REQUEST, *PSCARD_IO_REQUEST, *LPSCARD_IO_REQUEST;

#define MAX_ATR_SIZE			33
typedef struct{
	const char *szReader;
	void *pvUserData;
	DWORD dwCurrentState;
	DWORD dwEventState;
	DWORD cbAtr;
	unsigned char rgbAtr[MAX_ATR_SIZE];
}SCARD_READERSTATE, *LPSCARD_READERSTATE;




#define SCARD_AUTOALLOCATE (DWORD)(-1)



#define SCARD_S_SUCCESS				0x00000000
#define SCARD_E_NO_READERS_AVAILABLE    0x8010002E

#define SCARD_S_FAIL				0x80000000

#define SCARD_S_SOCKET_ERROR		0x88000001
#define SCARD_S_MEMORY_NOTENOUGH	0x88000002
#define SCARD_S_FORMATERROR			0x88000003
#define SCARD_S_NOTSUCHREADER		0x88000004
#define SCARD_S_POWERONERR			0x88000005
#define SCARD_S_NOTIMPLELMENTED		0x88100000



#define SCARD_SHARE_EXCLUSIVE		0x0001
#define SCARD_SHARE_SHARED			0x0002
#define SCARD_SHARE_DIRECT			0x0003


#define SCARD_STATE_UNAWARE			0x0000
#define SCARD_STATE_IGNORE			0x0001
#define SCARD_STATE_CHANGED			0x0002
#define SCARD_STATE_UNKNOWN			0x0004
#define SCARD_STATE_UNAVAILABLE		0x0008
#define SCARD_STATE_EMPTY			0x0010
#define SCARD_STATE_PRESENT			0x0020
#define SCARD_STATE_ATRMATCH		0x0040
#define SCARD_STATE_EXCLUSIVE		0x0080
#define SCARD_STATE_INUSE			0x0100
#define SCARD_STATE_MUTE			0x0200
#define SCARD_STATE_UNPOWERED		0x0400






#ifdef __cplusplus
extern "C"
{
#endif


#ifndef PCSC_API
#define PCSC_API
#endif

void FT_Init(int port);


PCSC_API ULONG FT_SCardEstablishContext(DWORD dwScope,LPCVOID pvReserved1,LPCVOID pvReserved2,LPSCARDCONTEXT phContext);
#define SCardEstablishContext	FT_SCardEstablishContext

PCSC_API ULONG FT_SCardReleaseContext(SCARDCONTEXT hContext);
#define SCardReleaseContext	FT_SCardReleaseContext


PCSC_API ULONG FT_SCardListReaders(SCARDCONTEXT hContext,LPCSTR mszGroups, LPSTR *mszReaders,LPDWORD pcchReaders);
#define SCardListReaders	FT_SCardListReaders


PCSC_API ULONG FT_SCardConnect(SCARDCONTEXT hContext,LPCSTR szReader,DWORD dwShareMode,DWORD dwPreferredProtocols,LPSCARDHANDLE phCard,LPDWORD pdwActiveProtocol);
#define SCardConnect	FT_SCardConnect

PCSC_API ULONG FT_SCardStatus(SCARDHANDLE hCard,LPSTR mszReaderName,LPDWORD pcchReaderLen,LPDWORD pdwState,LPDWORD pdwProtocol,LPBYTE pbAtr,LPDWORD pcbAtrLen);
#define SCardStatus	FT_SCardStatus

PCSC_API ULONG FT_SCardTransmit(SCARDHANDLE hCard,const SCARD_IO_REQUEST *pioSendPci,LPCBYTE pbSendBuffer, DWORD cbSendLength,SCARD_IO_REQUEST *pioRecvPci,LPBYTE pbRecvBuffer, LPDWORD pcbRecvLength);
#define SCardTransmit	FT_SCardTransmit

PCSC_API ULONG FT_SCardDisconnect(SCARDHANDLE hCard, DWORD dwDisposition);
#define SCardDisconnect	FT_SCardDisconnect


///////////////////////////////////////////////////////////
//////////////////////NOT IMPLEMENTED/////////////////////
///////////////////////////////////////////////////////////


PCSC_API ULONG FT_SCardIsValidContext(SCARDCONTEXT hContext);
#define SCardIsValidContext FT_SCardIsValidContext

PCSC_API ULONG FT_SCardReconnect(SCARDHANDLE hCard,DWORD dwShareMode,DWORD dwPreferredProtocols,DWORD dwInitialization,LPDWORD pdwActiveProtocol);
#define SCardReconnect FT_SCardReconnect

PCSC_API ULONG FT_SCardBeginTransaction(SCARDHANDLE hCard);
#define SCardBeginTransaction FT_SCardBeginTransaction

PCSC_API ULONG FT_SCardEndTransaction(SCARDHANDLE hCard, DWORD dwDisposition);
#define SCardEndTransaction FT_SCardEndTransaction 

PCSC_API ULONG FT_SCardGetStatusChange(SCARDCONTEXT hContext,DWORD dwTimeout,LPSCARD_READERSTATE rgReaderStates,DWORD cReaders);
#define SCardGetStatusChange FT_SCardGetStatusChange

PCSC_API ULONG FT_SCardControl(SCARDHANDLE hCard,DWORD dwControlCode,LPCVOID pbSendBuffer,DWORD cbSendLength,LPVOID pbRecvBuffer,DWORD cbRecvLength,LPDWORD lpBytesReturned);
#define SCardControl FT_SCardControl

PCSC_API ULONG FT_SCardListReaderGroups(SCARDCONTEXT hContext,LPSTR mszGroups,LPDWORD pcchGroups);
#define SCardListReaderGroups FT_SCardListReaderGroups

PCSC_API ULONG FT_SCardFreeMemory(SCARDCONTEXT hContext,LPCVOID pvMem);
#define SCardFreeMemory FT_SCardFreeMemory

PCSC_API ULONG FT_SCardCancel(SCARDCONTEXT hContext);
#define SCardCancel FT_SCardCancel

PCSC_API ULONG FT_SCardGetAttrib(SCARDHANDLE hCard,DWORD dwAttrId,LPBYTE pbAttr, LPDWORD pcbAttrLen);
#define SCardGetAttrib FT_SCardGetAttrib

PCSC_API ULONG FT_SCardSetAttrib(SCARDHANDLE hCard,DWORD dwAttrId,LPCBYTE pbAttr,DWORD cbAttrLen);
#define SCardSetAttrib FT_SCardSetAttrib



#ifdef __cplusplus
}
#endif


#endif
