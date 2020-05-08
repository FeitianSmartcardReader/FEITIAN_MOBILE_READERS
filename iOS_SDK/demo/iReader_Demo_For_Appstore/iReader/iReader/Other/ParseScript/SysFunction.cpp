#include "SysFunction.h"

// ����һ������
string SYS_Pop(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.empty())
    {
        return sTemp;
    }

    // ��ȡ���һ��Ԫ�أ���ɾ��
    sTemp = vParameter.back();
    vParameter.erase(vParameter.end() - 1);

    return sTemp;
}


// �����ݣ�һ��Ϊ�ַ�����ת����utf8��ʽ������
/*string SYS_Utf8_String(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.empty())
    {
        return "";
    }

    // ʹ�õ�һ��Ԫ�ؼ��ɣ���ת����16���Ƶ�ascii
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

    // ת��Utf-8��ʽ
    int nwLen = ::MultiByteToWideChar(CP_ACP, 0, str.c_str(), -1, NULL, 0);

    wchar_t * pwBuf = new wchar_t[nwLen + 1];//һ��Ҫ��1����Ȼ�����β��
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


// ������ = mid( ���ݣ� 10����offset�� 10����length )��Ҳ����ֻ��offset
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


// ������ = hmid( ���ݣ� 16����offset�� 16����length )��Ҳ����ֻ��offset
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


// ������ = left( ���ݣ� 10����length )
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


// ������ = hleft( ���ݣ� 16����length )
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


// ������ = right( ���ݣ� 10����length )
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


// ������ = hright( ���ݣ� 16����length )
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


// ������ = dup( 10�����ظ������� 16�������� )
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


// ������ = hdup( 16�����ظ������� 16�������� )
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


// ������ = fixed80( ���� )��������80 00 00 ������ 8�ֽڶ���
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


// ������ = fixed80_16( ���� )��������80 00 00 ������ 16�ֽڶ���
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


// ������ = add( 16��������1��16��������2 )�˼��㰴����1�ĳ���Ϊ������ȣ���������1�ĳ��ȣ���ʹ���µĳ��� �� add( ffff, 01 )������Ϊ010000��
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


// ������ = sub( 16��������1��16��������2 )
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


// ������ = mul( 16��������1��16��������2 )  �������ݵĳ��Ȳ�С������1�ĳ���
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


// ������ = div( 16��������1��16��������2 )  �������ݵĳ��Ȳ�С������1�ĳ���
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


// ������ = Mod( 16��������1��16��������2 )  �������ݳ��Ȳ���������2�ĳ���
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


// ������ = and( 16��������1��16��������2 )
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


// ������ = Xor( 16��������1��16��������2 )  �������Ϊ����2�ĳ���
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


// ������ = or( 16��������1��16��������2 )  �������Ϊ����2�ĳ���
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





// ������ = hex2int( 16�������� )
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


// ������ = int2hex( 10�������� )
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


// sleep 10 ���ƺ�����
string SYS_Sleep(vector<string> &vParameter)
{
    string sTemp = "";
    if (vParameter.size() != 1)
    {
        return "";
    }

    int nTime = strtol(vParameter.at(0).c_str(), NULL, 10);

#ifdef _WIN32
    Sleep(nTime);           //Sleep�����ĵ�λΪ����
#else
    usleep(nTime * 1000);   //usleep�����ĵ�λΪ΢��
#endif

    return sTemp;
}


// ������ = datalen( ���� ) ����2�ֽڳ�16���Ƶ����ݵĳ���
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


// ������ = strlen( ���� ) ��datalen���ƣ�������lenС��0x100ʱ������һ���ֽڵ�����
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