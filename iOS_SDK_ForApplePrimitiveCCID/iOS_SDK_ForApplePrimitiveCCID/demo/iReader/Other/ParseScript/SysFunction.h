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

//为了调用方便，本文件所有函数的参数均使用vector<string> &类型

//弹出一个参数
string SYS_Pop(vector<string> &vParameter);

//************************************************ 数据处理部分 ************************************************//

// 将数据（一般为字符串）转换成utf8格式的数据
//string SYS_Utf8_String(vector<string> &vParameter);

// 变量名 = mid( 数据， 10进制offset， 10进制length )，也可以只接offset
string SYS_Mid(vector<string> &vParameter);

// 变量名 = hmid( 数据， 16进制offset， 16进制length )，也可以只接offset
string SYS_HMid(vector<string> &vParameter);

// 变量名 = left( 数据， 10进制length )
string SYS_Left(vector<string> &vParameter);

// 变量名 = hleft( 数据， 16进制length )
string SYS_HLeft(vector<string> &vParameter);

// 变量名 = right( 数据， 10进制length )
string SYS_Right(vector<string> &vParameter);

// 变量名 = hright( 数据， 16进制length )
string SYS_HRight(vector<string> &vParameter);

// 变量名 = dup( 10进制重复次数， 16进制数据 )
string SYS_Dup(vector<string> &vParameter);

// 变量名 = hdup( 16进制重复次数， 16进制数据 )
string SYS_HDup(vector<string> &vParameter);

// 变量名 = fixed80( 数据 )。数据以80 00 00 。。。 8字节对齐
string SYS_Fixed80(vector<string> &vParameter);

// 变量名 = fixed80_16( 数据 )。数据以80 00 00 。。。 16字节对齐
string SYS_Fixed80_16(vector<string> &vParameter);

// 变量名 = add( 16进制数据1，16进制数据2 )此计算按数据1的长度为结果长度，超过数据1的长度，则使用新的长度 如 add( ffff, 01 )，则结果为010000。
string SYS_Add(vector<string> &vParameter);

// 变量名 = sub( 16进制数据1，16进制数据2 )
string SYS_Sub(vector<string> &vParameter);

// 变量名 = mul( 16进制数据1，16进制数据2 )  返回数据的长度不小于数据1的长度
string SYS_Mul(vector<string> &vParameter);

// 变量名 = div( 16进制数据1，16进制数据2 )  返回数据的长度不小于数据1的长度
string SYS_Div(vector<string> &vParameter);

// 变量名 = Mod( 16进制数据1，16进制数据2 )
string SYS_Mod(vector<string> &vParameter);

// 变量名 = and( 16进制数据1，16进制数据2 )
string SYS_And(vector<string> &vParameter);

// 变量名 = Xor( 16进制数据1，16进制数据2 )  结果长度为数据2的长度
string SYS_Xor(vector<string> &vParameter);

// 变量名 = or( 16进制数据1，16进制数据2 )  结果长度为数据2的长度
string SYS_Or(vector<string> &vParameter);

// 变量名 = hex2int( 16进制数据 )
string SYS_Hex2Int(vector<string> &vParameter);

// 变量名 = int2hex( 10进制数据 )
string SYS_Int2Hex(vector<string> &vParameter);

// sleep 10 进制毫秒数
string SYS_Sleep(vector<string> &vParameter);

// 变量名 = datalen( 数据 ) 返回2字节长16进制的数据的长度
string SYS_Datalen(vector<string> &vParameter);

// 变量名 = strlen( 数据 ) 与datalen相似，不过当len小于0x100时，返回一个字节的数据
string SYS_Strlen(vector<string> &vParameter);

#endif
