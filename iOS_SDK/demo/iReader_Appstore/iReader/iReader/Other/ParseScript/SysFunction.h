#ifndef __SYSFUNCTION___
#define __SYSFUNCTION___

#include <fstream>
#include <iostream> 
#include <string>
#include <algorithm>
#include <vector>
#include <map>
#include <list>

#ifdef _WIN32
#include <windows.h>
#else
#include <sys/time.h>
#include <unistd.h>
//typedef unsigned long       DWORD;
////typedef int                 BOOL;
//typedef unsigned char       BYTE;
//typedef unsigned short      WORD;
//typedef long                LONG;
#include "wintypes.h"
#endif

using namespace std;

//Ϊ�˵��÷��㣬���ļ����к����Ĳ�����ʹ��vector<string> &����

//����һ������
string SYS_Pop(vector<string> &vParameter);

//************************************************ ���ݴ����� ************************************************//

// �����ݣ�һ��Ϊ�ַ�����ת����utf8��ʽ������
//string SYS_Utf8_String(vector<string> &vParameter);

// ������ = mid( ���ݣ� 10����offset�� 10����length )��Ҳ����ֻ��offset
string SYS_Mid(vector<string> &vParameter);

// ������ = hmid( ���ݣ� 16����offset�� 16����length )��Ҳ����ֻ��offset
string SYS_HMid(vector<string> &vParameter);

// ������ = left( ���ݣ� 10����length )
string SYS_Left(vector<string> &vParameter);

// ������ = hleft( ���ݣ� 16����length )
string SYS_HLeft(vector<string> &vParameter);

// ������ = right( ���ݣ� 10����length )
string SYS_Right(vector<string> &vParameter);

// ������ = hright( ���ݣ� 16����length )
string SYS_HRight(vector<string> &vParameter);

// ������ = dup( 10�����ظ������� 16�������� )
string SYS_Dup(vector<string> &vParameter);

// ������ = hdup( 16�����ظ������� 16�������� )
string SYS_HDup(vector<string> &vParameter);

// ������ = fixed80( ���� )��������80 00 00 ������ 8�ֽڶ���
string SYS_Fixed80(vector<string> &vParameter);

// ������ = fixed80_16( ���� )��������80 00 00 ������ 16�ֽڶ���
string SYS_Fixed80_16(vector<string> &vParameter);

// ������ = add( 16��������1��16��������2 )�˼��㰴����1�ĳ���Ϊ������ȣ���������1�ĳ��ȣ���ʹ���µĳ��� �� add( ffff, 01 )������Ϊ010000��
string SYS_Add(vector<string> &vParameter);

// ������ = sub( 16��������1��16��������2 )
string SYS_Sub(vector<string> &vParameter);

// ������ = mul( 16��������1��16��������2 )  �������ݵĳ��Ȳ�С������1�ĳ���
string SYS_Mul(vector<string> &vParameter);

// ������ = div( 16��������1��16��������2 )  �������ݵĳ��Ȳ�С������1�ĳ���
string SYS_Div(vector<string> &vParameter);

// ������ = Mod( 16��������1��16��������2 )
string SYS_Mod(vector<string> &vParameter);

// ������ = and( 16��������1��16��������2 )
string SYS_And(vector<string> &vParameter);

// ������ = Xor( 16��������1��16��������2 )  �������Ϊ����2�ĳ���
string SYS_Xor(vector<string> &vParameter);

// ������ = or( 16��������1��16��������2 )  �������Ϊ����2�ĳ���
string SYS_Or(vector<string> &vParameter);

// ������ = hex2int( 16�������� )
string SYS_Hex2Int(vector<string> &vParameter);

// ������ = int2hex( 10�������� )
string SYS_Int2Hex(vector<string> &vParameter);

// sleep 10 ���ƺ�����
string SYS_Sleep(vector<string> &vParameter);

// ������ = datalen( ���� ) ����2�ֽڳ�16���Ƶ����ݵĳ���
string SYS_Datalen(vector<string> &vParameter);

// ������ = strlen( ���� ) ��datalen���ƣ�������lenС��0x100ʱ������һ���ֽڵ�����
string SYS_Strlen(vector<string> &vParameter);

#endif
