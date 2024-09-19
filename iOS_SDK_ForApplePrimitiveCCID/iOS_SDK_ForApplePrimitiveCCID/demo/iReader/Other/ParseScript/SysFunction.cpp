#include "SysFunction.h"

// 弹出一个参数
string SYS_Pop(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.empty())
    {
        return sTemp;
    }

    // 获取最后一个元素，并删除
    sTemp = vParameter.back();
    vParameter.erase(vParameter.end() - 1);

    return sTemp;
}


// 将数据（一般为字符串）转换成utf8格式的数据
/*string SYS_Utf8_String(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.empty())
    {
        return "";
    }

    // 使用第一个元素即可，先转换成16进制的ascii
    sTemp = vParameter.at(0);
    string str = "";
    char c[3] = { 0 };
    for (unsigned int i = 0; i < sTemp.length(); i++)
    {
        sprintf(c, "%02X", sTemp[i]);
        str += c;
    }
    if (str.empty())
    {
        return "";
    }

    // 转成Utf-8格式
    int nwLen = ::MultiByteToWideChar(CP_ACP, 0, str.c_str(), -1, NULL, 0);

    wchar_t * pwBuf = new wchar_t[nwLen + 1];//一定要加1，不然会出现尾巴
    ZeroMemory(pwBuf, nwLen * 2 + 2);

    ::MultiByteToWideChar(CP_ACP, 0, str.c_str(), str.length(), pwBuf, nwLen);

    int nLen = ::WideCharToMultiByte(CP_UTF8, 0, pwBuf, -1, NULL, NULL, NULL, NULL);

    char * pBuf = new char[nLen + 1];
    ZeroMemory(pBuf, nLen + 1);

    ::WideCharToMultiByte(CP_UTF8, 0, pwBuf, nwLen, pBuf, nLen, NULL, NULL);

    sTemp = pBuf;

    delete[]pwBuf;
    delete[]pBuf;

    pwBuf = NULL;
    pBuf = NULL;

    return sTemp;
}*/


// 变量名 = mid( 数据， 10进制offset， 10进制length )，也可以只接offset
string SYS_Mid(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() < 2)
    {
        return "";
    }

    int nOffset = strtol(vParameter.at(1).c_str(), NULL, 10);
    int nLength = 0;

    if ((string::size_type)(nOffset * 2) >= vParameter.at(0).length())
    {
        return "";
    }

    if (vParameter.size() == 2)
    {
        sTemp = vParameter.at(0).substr(nOffset * 2);
    }
    else
    {
        nLength = strtol(vParameter.at(2).c_str(), NULL, 10);
        sTemp = vParameter.at(0).substr(nOffset * 2, nLength * 2);
    }

    return sTemp;
}


// 变量名 = hmid( 数据， 16进制offset， 16进制length )，也可以只接offset
string SYS_HMid(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() < 2)
    {
        return "";
    }

    int nOffset = strtol(vParameter.at(1).c_str(), NULL, 16);
    int nLength = 0;

    if ((string::size_type)(nOffset * 2) >= vParameter.at(0).length())
    {
        return "";
    }

    if (vParameter.size() == 2)
    {
        sTemp = vParameter.at(0).substr(nOffset * 2);
    }
    else
    {
        nLength = strtol(vParameter.at(2).c_str(), NULL, 16);
        sTemp = vParameter.at(0).substr(nOffset * 2, nLength * 2);
    }

    return sTemp;
}


// 变量名 = left( 数据， 10进制length )
string SYS_Left(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    int nLen = strtol(vParameter.at(1).c_str(), NULL, 10);

    if (vParameter.at(0).length() < (string::size_type)(nLen * 2))
    {
        sTemp = vParameter.at(0);
    }
    else
    {
        sTemp = vParameter.at(0).substr(0, nLen * 2);
    }
    
    return sTemp;
}


// 变量名 = hleft( 数据， 16进制length )
string SYS_HLeft(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    int nLen = strtol(vParameter.at(1).c_str(), NULL, 16);

    if (vParameter.at(0).length() < (string::size_type)(nLen * 2))
    {
        sTemp = vParameter.at(0);
    }
    else
    {
        sTemp = vParameter.at(0).substr(0, nLen * 2);
    }

    return sTemp;
}


// 变量名 = right( 数据， 10进制length )
string SYS_Right(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    int nLen = strtol(vParameter.at(1).c_str(), NULL, 10);

    if (vParameter.at(0).length() < (string::size_type)(nLen * 2))
    {
        sTemp = vParameter.at(0);
    }
    else
    {
        sTemp = vParameter.at(0).substr(vParameter.at(0).length() - nLen * 2, nLen * 2);
    }

    return sTemp;
}


// 变量名 = hright( 数据， 16进制length )
string SYS_HRight(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    int nLen = strtol(vParameter.at(1).c_str(), NULL, 16);

    if (vParameter.at(0).length() < (string::size_type)(nLen * 2))
    {
        sTemp = vParameter.at(0);
    }
    else
    {
        sTemp = vParameter.at(0).substr(vParameter.at(0).length() - nLen * 2, nLen * 2);
    }

    return sTemp;
}


// 变量名 = dup( 10进制重复次数， 16进制数据 )
string SYS_Dup(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    int nNum = strtol(vParameter.at(0).c_str(), NULL, 10);
    for (int i = 0; i < nNum; i++)
    {
        sTemp += vParameter.at(1);
    }

    return sTemp;
}


// 变量名 = hdup( 16进制重复次数， 16进制数据 )
string SYS_HDup(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    int nNum = strtol(vParameter.at(0).c_str(), NULL, 16);
    for (int i = 0; i < nNum; i++)
    {
        sTemp += vParameter.at(1);
    }

    return sTemp;
}


// 变量名 = fixed80( 数据 )。数据以80 00 00 。。。 8字节对齐
string SYS_Fixed80(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 1)
    {
        return "";
    }

    sTemp = vParameter.at(0) + "80";
    int nSize = 8 - (sTemp.length() / 2) % 8;
    for (int i = 0; i < nSize; i++)
    {
        sTemp += "00";
    }

    return sTemp;
}


// 变量名 = fixed80_16( 数据 )。数据以80 00 00 。。。 16字节对齐
string SYS_Fixed80_16(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 1)
    {
        return "";
    }

    sTemp = vParameter.at(0) + "80";
    int nSize = 16 - (sTemp.length() / 2) % 16;
    for (int i = 0; i < nSize; i++)
    {
        sTemp += "00";
    }

    return sTemp;
}


// 变量名 = add( 16进制数据1，16进制数据2 )此计算按数据1的长度为结果长度，超过数据1的长度，则使用新的长度 如 add( ffff, 01 )，则结果为010000。
string SYS_Add(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    long nData_1 = strtol(vParameter.at(0).c_str(), NULL, 16);
    long nData_2 = strtol(vParameter.at(1).c_str(), NULL, 16);

    long nResult = nData_1 + nData_2;
    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)nResult);
    sTemp = sResult;

    if (sTemp.size() < vParameter.at(0).size())
    {
        string s = "";
        s.append(vParameter.at(0).size() - sTemp.size(), '0');
        sTemp = s + sTemp;
    }

    return sTemp;
}


// 变量名 = sub( 16进制数据1，16进制数据2 )
string SYS_Sub(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    long nData_1 = strtol(vParameter.at(0).c_str(), NULL, 16);
    long nData_2 = strtol(vParameter.at(1).c_str(), NULL, 16);

    long nResult = nData_1 - nData_2;
    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)nResult);
    sTemp = sResult;

    return sTemp;
}


// 变量名 = mul( 16进制数据1，16进制数据2 )  返回数据的长度不小于数据1的长度
string SYS_Mul(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    long nData_1 = strtol(vParameter.at(0).c_str(), NULL, 16);
    long nData_2 = strtol(vParameter.at(1).c_str(), NULL, 16);

    long nResult = nData_1 * nData_2;
    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)nResult);
    sTemp = sResult;

    if (sTemp.size() < vParameter.at(0).size())
    {
        string s = "";
        s.append(vParameter.at(0).size() - sTemp.size(), '0');
        sTemp = s + sTemp;
    }

    return sTemp;
}


// 变量名 = div( 16进制数据1，16进制数据2 )  返回数据的长度不小于数据1的长度
string SYS_Div(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    long nData_1 = strtol(vParameter.at(0).c_str(), NULL, 16);
    long nData_2 = strtol(vParameter.at(1).c_str(), NULL, 16);
    if (nData_2 == 0)
    {
        return "";
    }

    long nResult = nData_1 / nData_2;
    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)nResult);
    sTemp = sResult;

    if (sTemp.size() < vParameter.at(0).size())
    {
        string s = "";
        s.append(vParameter.at(0).size() - sTemp.size(), '0');
        sTemp = s + sTemp;
    }

    return sTemp;
}


// 变量名 = Mod( 16进制数据1，16进制数据2 )  返回数据长度不大于数据2的长度
string SYS_Mod(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    long nData_1 = strtol(vParameter.at(0).c_str(), NULL, 16);
    long nData_2 = strtol(vParameter.at(1).c_str(), NULL, 16);
    if (nData_2 == 0)
    {
        return "";
    }

    long nResult = nData_1 % nData_2;
    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)nResult);
    sTemp = sResult;

    return sTemp;
}


// 变量名 = and( 16进制数据1，16进制数据2 )
string SYS_And(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    long nData_1 = strtol(vParameter.at(0).c_str(), NULL, 16);
    long nData_2 = strtol(vParameter.at(1).c_str(), NULL, 16);
    if (nData_2 == 0)
    {
        return "";
    }

    long nResult = nData_1 & nData_2;
    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)nResult);
    sTemp = sResult;

    return sTemp;
}


// 变量名 = Xor( 16进制数据1，16进制数据2 )  结果长度为数据2的长度
string SYS_Xor(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    long nData_1 = strtol(vParameter.at(0).c_str(), NULL, 16);
    long nData_2 = strtol(vParameter.at(1).c_str(), NULL, 16);
    if (nData_2 == 0)
    {
        return "";
    }

    long nResult = nData_1 ^ nData_2;
    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)nResult);
    sTemp = sResult;

    if (sTemp.size() < vParameter.at(1).size())
    {
        string s = "";
        s.append(vParameter.at(1).size() - sTemp.size(), '0');
        sTemp = s + sTemp;
    }

    return sTemp;
}


// 变量名 = or( 16进制数据1，16进制数据2 )  结果长度为数据2的长度
string SYS_Or(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 2)
    {
        return "";
    }

    long nData_1 = strtol(vParameter.at(0).c_str(), NULL, 16);
    long nData_2 = strtol(vParameter.at(1).c_str(), NULL, 16);
    if (nData_2 == 0)
    {
        return "";
    }

    long nResult = nData_1 | nData_2;
    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)nResult);
    sTemp = sResult;

    if (sTemp.size() < vParameter.at(1).size())
    {
        string s = "";
        s.append(vParameter.at(1).size() - sTemp.size(), '0');
        sTemp = s + sTemp;
    }

    return sTemp;
}





// 变量名 = hex2int( 16进制数据 )
string SYS_Hex2Int(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 1)
    {
        return "";
    }

    int nResult = strtol(vParameter.at(0).c_str(), NULL, 16);

    char sResult[200] = { 0 };
    sprintf(sResult, "%d", nResult);
    sTemp = sResult;

    return sTemp;
}


// 变量名 = int2hex( 10进制数据 )
string SYS_Int2Hex(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 1)
    {
        return "";
    }

    int nResult = strtol(vParameter.at(0).c_str(), NULL, 10);

    char sResult[200] = { 0 };
    sprintf(sResult, "%X", nResult);
    sTemp = sResult;

    return sTemp;
}


// sleep 10 进制毫秒数
string SYS_Sleep(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 1)
    {
        return "";
    }

    int nTime = strtol(vParameter.at(0).c_str(), NULL, 10);

#ifdef _WIN32
    Sleep(nTime);           //Sleep函数的单位为毫秒
#else
    usleep(nTime * 1000);   //usleep函数的单位为微秒
#endif

    return sTemp;
}


// 变量名 = datalen( 数据 ) 返回2字节长16进制的数据的长度
string SYS_Datalen(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 1)
    {
        return "";
    }

    char sResult[20] = { 0 };
    sprintf(sResult, "%04X", (WORD)(vParameter.at(0).length() / 2));
    sTemp = sResult;

    return sTemp;
}


// 变量名 = strlen( 数据 ) 与datalen相似，不过当len小于0x100时，返回一个字节的数据
string SYS_Strlen(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 1)
    {
        return "";
    }

    char sResult[20] = { 0 };
    sprintf(sResult, "%X", (WORD)(vParameter.at(0).length() / 2));
    sTemp = sResult;

    return sTemp;
}