#include "ParseScript.h"

#define FILE_ANSI       0
#define FILE_UTF8       1
#define FILE_UNICODE    2

#ifdef _WIN32
#else
#include <iconv.h>
#endif

extern SCARDHANDLE gCardHandle;
extern SCARDCONTEXT gContxtHandle;

//UTF8תANSI
void UTF8toANSI(string &strUTF8)
{
#ifdef _WIN32
    //��ȡת��Ϊ���ֽں���Ҫ�Ļ�������С���������ֽڻ�����
    int nLen = MultiByteToWideChar(CP_UTF8, NULL, strUTF8.c_str(), -1, NULL, NULL);
    wchar_t *wszBuffer = new wchar_t[nLen + 1];
    nLen = MultiByteToWideChar(CP_UTF8, NULL, strUTF8.c_str(), -1, wszBuffer, nLen);
    wszBuffer[nLen] = 0;

    nLen = WideCharToMultiByte(936, NULL, wszBuffer, -1, NULL, NULL, NULL, NULL);
    char *szBuffer = new char[nLen + 1];
    nLen = WideCharToMultiByte(936, NULL, wszBuffer, -1, szBuffer, nLen, NULL, NULL);
    szBuffer[nLen] = 0;

    strUTF8 = szBuffer;
    //�����ڴ�
    delete[]szBuffer;
    delete[]wszBuffer;
    szBuffer = NULL;
    wszBuffer = NULL;
#endif
}

//ANSIתUTF8
void ANSItoUTF8(string &strAnsi)
{
#ifdef _WIN32
    //��ȡת��Ϊ���ֽں���Ҫ�Ļ�������С���������ֽڻ�������936Ϊ��������GB2312����ҳ
    int nLen = MultiByteToWideChar(936,NULL,strAnsi.c_str(),-1,NULL,NULL);
    wchar_t *wszBuffer = new wchar_t[nLen+1];
    nLen = MultiByteToWideChar(936,NULL,strAnsi.c_str(),-1,wszBuffer,nLen);
    wszBuffer[nLen] = 0;
    //��ȡתΪUTF8���ֽں���Ҫ�Ļ�������С���������ֽڻ�����
    nLen = WideCharToMultiByte(CP_UTF8,NULL,wszBuffer,-1,NULL,NULL,NULL,NULL);
    char *szBuffer = new char[nLen+1];
    nLen = WideCharToMultiByte(CP_UTF8,NULL,wszBuffer,-1,szBuffer,nLen,NULL,NULL);
    szBuffer[nLen] = 0;

    strAnsi = szBuffer;
    //�ڴ�����
    delete []wszBuffer;
    delete []szBuffer;
    wszBuffer = NULL;
    szBuffer = NULL;
#else
    iconv_t cd;
    cd = iconv_open("UTF-8","gb18030//TRANSLIT");
    if (cd == 0) return;

    char *s_outbuffer = new char[strAnsi.length() + 1];
    memset(s_outbuffer, 0, strAnsi.length() + 1);
    char* srcStart = (char*)strAnsi.c_str();// srcBufferͬ��������wchar_t������Ҳ������ǿ��ת��
    size_t nStart = strAnsi.length();
    size_t nResult = 0;
    char* tempOutBuffer = s_outbuffer;//Ҫ�������ʱ����������iconv��ֱ�Ӹ�дs_outbufferָ��
    size_t ret = iconv(cd, (char**)&srcStart, &nStart, &tempOutBuffer, &nResult);
    iconv_close(cd);
#endif
}

//UNICODEתANSI
string UNICODEtoANSI(wchar_t* str)
{
    string strUnicode = "";
#ifdef _WIN32
    char* result = NULL;
    int textlen = 0;
    textlen = WideCharToMultiByte( CP_ACP, 0, str, -1, NULL, 0, NULL, NULL );
    result = new char[(textlen+1)*sizeof(char)];
    memset( result, 0, sizeof(char) * ( textlen + 1 ) );
    WideCharToMultiByte( CP_ACP, 0, str, -1, result, textlen, NULL, NULL );
    strUnicode = result;
    delete []result;
    result = NULL;
#else
#endif
    return strUnicode;
}

//UNICODEתUTF8
string UNICODEtoUTF8(wchar_t* str)
{
    string strUnicode = "";
#ifdef _WIN32
#else
    iconv_t cd;
    cd = iconv_open("UTF-8", "WCHAR_T");  //WCHAR_T��unicode
    if (cd == 0) return "";

    int inBytes = wcslen(str) * sizeof(wchar_t);
    int outBytes = 6 * wcslen(str) ; // 6Ϊutf-8��һ���ַ�������ֽ���
    char * out = new char[ outBytes + 1 ];
    memset( out, 0, outBytes + 1);
    char * tmpout = out;

    iconv(cd, (char **) &str, (size_t *)&inBytes, (char **) &tmpout, (size_t *)&outBytes);
    iconv_close(cd);
    strUnicode = out;
    delete []out;
    out = NULL;
    tmpout = NULL;
#endif
    return strUnicode;
}


//�жϽű��ļ��ı����ʽ
int GetEncodingFormat(string sFileName)
{
    int fileType = FILE_ANSI;
    //std::ifstream file;
    //file.open(sFileName.c_str(), std::ios_base::in);
    FILE *pFile = NULL;
    char szFlag[30] = { 0 };

    if((pFile = fopen(sFileName.c_str(),"r+t"))!=NULL)
    {
        fread(szFlag, sizeof(char), 3, pFile);
        fclose(pFile);

        if ((unsigned char)szFlag[0] == 0xFF
            && (unsigned char)szFlag[1] == 0xFE)
        {
            fileType = FILE_UNICODE;
        }
        else if ((unsigned char)szFlag[0] == 0xEF
            && (unsigned char)szFlag[1] == 0xBB
            && (unsigned char)szFlag[2] == 0xBF)
        {
            fileType = FILE_UTF8;
        }
    }

    return fileType;
}


CParseScript::CParseScript()
{
	m_bTime = false;
	m_Time = 0;

    //ϵͳ����
    m_SysVer.insert(pair<string, string>("SW", ""));                    //���ص�SW
    m_SysVer.insert(pair<string, string>("RESULT", ""));                //apdu���淵��ֵ
    m_SysVer.insert(pair<string, string>("PERFORMANCETIMES", "0A"));    //���ܴ�����Ĭ��10��

    //ϵͳ��������ָ��
    m_FunPtr.insert(pair<string, FUN_PTR>("POP",    &SYS_Pop));
    //m_FunPtr.insert(pair<string, FUN_PTR>("UTF8_STRING", &SYS_Utf8_String));
    m_FunPtr.insert(pair<string, FUN_PTR>("MID",    &SYS_Mid));
    m_FunPtr.insert(pair<string, FUN_PTR>("HMID",   &SYS_HMid));
    m_FunPtr.insert(pair<string, FUN_PTR>("LEFT",   &SYS_Left));
    m_FunPtr.insert(pair<string, FUN_PTR>("HLEFT",  &SYS_HLeft));
    m_FunPtr.insert(pair<string, FUN_PTR>("RIGHT",  &SYS_Right));
    m_FunPtr.insert(pair<string, FUN_PTR>("HRIGHT", &SYS_HRight));
    m_FunPtr.insert(pair<string, FUN_PTR>("DUP",    &SYS_Dup));
    m_FunPtr.insert(pair<string, FUN_PTR>("HDUP",   &SYS_HDup));
    m_FunPtr.insert(pair<string, FUN_PTR>("FIXED80",    &SYS_Fixed80));
    m_FunPtr.insert(pair<string, FUN_PTR>("FIXED80_16", &SYS_Fixed80_16));
    m_FunPtr.insert(pair<string, FUN_PTR>("ADD",    &SYS_Add));
    m_FunPtr.insert(pair<string, FUN_PTR>("SUB",    &SYS_Sub));
    m_FunPtr.insert(pair<string, FUN_PTR>("MUL",    &SYS_Mul));
    m_FunPtr.insert(pair<string, FUN_PTR>("DIV",    &SYS_Div));
    m_FunPtr.insert(pair<string, FUN_PTR>("MOD",    &SYS_Mod));
    m_FunPtr.insert(pair<string, FUN_PTR>("AND",    &SYS_And));
    m_FunPtr.insert(pair<string, FUN_PTR>("XOR",    &SYS_Xor));
    m_FunPtr.insert(pair<string, FUN_PTR>("OR",     &SYS_Or));

    m_FunPtr.insert(pair<string, FUN_PTR>("HEX2INT",    &SYS_Hex2Int));
    m_FunPtr.insert(pair<string, FUN_PTR>("INT2HEX",    &SYS_Int2Hex));
    m_FunPtr.insert(pair<string, FUN_PTR>("SLEEP",      &SYS_Sleep));
    m_FunPtr.insert(pair<string, FUN_PTR>("DATALEN",    &SYS_Datalen));
    m_FunPtr.insert(pair<string, FUN_PTR>("STRLEN",     &SYS_Strlen));
}

CParseScript::~CParseScript()
{}


/*
* ********************************************************************
* ��������:  HexStrToByte
* ����˵��:  ʮ�������ַ���ת��Ϊ�ֽ���
* д������:  2019/01/03
* ********************************************************************
*/
void HexStrToByte(const char* source, BYTE* dest, int *destLen)
{
    short i;
    BYTE highByte, lowByte;

    char sTemp[10000] = { 0 };
    int sTempLen = 0;

    //ɾ�����пո�
    int m = -1;
    while (source[++m])
    {
        if (source[m] != ' ')
            sTemp[sTempLen++] = source[m];

    }
    sTemp[sTempLen] = '\0';

    for (i = 0; i < sTempLen; i += 2)
    {
        highByte = toupper(sTemp[i]);
        lowByte = toupper(sTemp[i + 1]);

        if (highByte > 0x39)
            highByte -= 0x37;
        else
            highByte -= 0x30;

        if (lowByte > 0x39)
            lowByte -= 0x37;
        else
            lowByte -= 0x30;

        dest[i / 2] = (highByte << 4) | lowByte;
    }

    *destLen = i / 2;
}


/*
* ********************************************************************
* ��������:  Byte2Hex
* ����˵��:  �ֽ���ת����ʮ�������ַ���
* д������:  2019/01/03
* ********************************************************************
*/
string Byte2Hex(BYTE bArray[], int bArray_len)
{
    string strHex = "";
    int nIndex = 0;
    for(int i = 0; i < bArray_len; i++)
    {
        int high = bArray[i] / 16, low = bArray[i] % 16;
        strHex += (high < 10) ? ('0' + high) : ('A' + high - 10);
        strHex += (low < 10) ? ('0' + low) : ('A' + low - 10);
        nIndex += 2;
    }
    return strHex;
}


/*
* ********************************************************************
* ��������:  split
* ����˵��:  �ָ��ַ�����sSeperator�����������ָ��������طָ�֮���vector
* д������:  2019/01/03
* ********************************************************************
*/
vector<string> CParseScript::split(const string &sSrc, const string &sSeperator)
{
    vector<string> result;
    typedef string::size_type string_size;
    string_size i = 0;

    while (i != sSrc.size())
    {
        //�ҵ��ַ������׸������ڷָ�������ĸ��
        int flag = 0;
        while (i != sSrc.size() && flag == 0)
        {
            flag = 1;
            for (string_size x = 0; x < sSeperator.size(); ++x)
            {
                if (sSrc[i] == sSeperator[x])
                {
                    string s = sSrc.substr(i, 1);
                    if (!s.empty())
                    {
                        result.push_back(s);
                    }
                    
                    ++i;
                    flag = 0;
                    break;
                }
            }                
        }

        //�ҵ���һ���ָ������������ָ���֮����ַ���ȡ����
        flag = 0;
        string_size j = i;
        while (j != sSrc.size() && flag == 0) 
        {
            for (string_size x = 0; x < sSeperator.size(); ++x)
            {
                if (sSrc[j] == sSeperator[x])
                {
                    flag = 1;
                    break;
                }
            }
                
            if (flag == 0)
            {
                ++j;
            }                
        }

        if (i != j) 
        {
            string sTemp = sSrc.substr(i, j - i);
            string sLeft = "";
            string sRight = "";

            //���ǰһ��Ԫ����$������Ҫ���տո����]�ٷָ�һ��
            if (!result.empty() && result.back() == "$")
            {
                //�����Ƿ���[]
                string::size_type nPos = sTemp.find_first_of("]");
                if (nPos != string::npos)
                {
                    sLeft = sTemp.substr(0, nPos + 1);
                    sRight = sTemp.substr(nPos + 1);

                    //ɾ���ո��\t
                    sLeft.erase(remove(sLeft.begin(), sLeft.end(), ' '), sLeft.end());
                    sRight.erase(remove(sRight.begin(), sRight.end(), ' '), sRight.end());
                    sLeft.erase(remove(sLeft.begin(), sLeft.end(), '\t'), sLeft.end());
                    sRight.erase(remove(sRight.begin(), sRight.end(), '\t'), sRight.end());

                    if (!sLeft.empty())
                    {
                        result.push_back(sLeft);
                    }
                    if (!sRight.empty())
                    {
                        result.push_back(sRight);
                    }
                }
                else
                {
                    //û��[]������ҿո�
                    nPos = sTemp.find_first_of(" ");
                    if (nPos != string::npos)
                    {
                        sLeft = sTemp.substr(0, nPos);
                        sRight = sTemp.substr(nPos);

                        //ɾ���ո��\t
                        sLeft.erase(remove(sLeft.begin(), sLeft.end(), ' '), sLeft.end());
                        sRight.erase(remove(sRight.begin(), sRight.end(), ' '), sRight.end());
                        sLeft.erase(remove(sLeft.begin(), sLeft.end(), '\t'), sLeft.end());
                        sRight.erase(remove(sRight.begin(), sRight.end(), '\t'), sRight.end());

                        if (!sLeft.empty())
                        {
                            result.push_back(sLeft);
                        }
                        if (!sRight.empty())
                        {
                            result.push_back(sRight);
                        }
                    }
                    else
                    {
                        if (!sTemp.empty())
                        {
                            result.push_back(sTemp);
                        }                        
                    }
                }                
            }
            else if (!result.empty() && result.back() == "\"")
            {
                if (!sTemp.empty())
                {
                    result.push_back(sTemp);
                }
            }
            else
            {
                //ɾ���ո��\t��������vector
                sTemp.erase(remove(sTemp.begin(), sTemp.end(), ' '), sTemp.end());
                sTemp.erase(remove(sTemp.begin(), sTemp.end(), '\t'), sTemp.end());

                if (!sTemp.empty())
                {
                    result.push_back(sTemp);
                }
            }
            i = j;
        }
    }
    return result;
}


/*
* ********************************************************************
* ��������:  SetVarValue
* ����˵��:  ����ϵͳ������sVarName����������sVarValue����������
* д������:  2019/01/03
* ********************************************************************
*/
void CParseScript::SetVarValue(string sVarName, string sVarValue)
{
    //�����2������������
    string sTemp = "";
    if (sVarName == "A" || sVarName == "B" || sVarName == "C" ||
        sVarName == "D" || sVarName == "E" || sVarName == "F" || sVarName == "G")
    {
        sTemp.append(sVarValue.size() % 2, '0');
    } 
    else if (sVarName == "I" || sVarName == "J" || sVarName == "K")
    {
        if (sVarValue.size() < 4)
        {
            sTemp.append(4 - sVarValue.size(), '0');
        }
    }
    else if (sVarName == "L" || sVarName == "M" || sVarName == "N")
    {
        if (sVarValue.size() < 8)
        {
            sTemp.append(8 - sVarValue.size(), '0');
        }
    }
    else
    {
        sTemp.append(sVarValue.size() % 2, '0');
    }
    
    sVarValue = sTemp + sVarValue;

    map<string, string>::iterator it = m_SysVer.find(sVarName);
    if (it != m_SysVer.end())
    {
        m_SysVer[sVarName] = sVarValue;
    } 
    else
    {
        m_SysVer.insert(pair<string, string>(sVarName, sVarValue));
    }
}


/*
* ********************************************************************
* ��������:  GetVarValue
* ����˵��:  ��ȡϵͳ������sVarName��������
* д������:  2019/01/03
* ********************************************************************
*/
string CParseScript::GetVarValue(string sVarName)
{
    map<string, string>::iterator it = m_SysVer.find(sVarName);
    if (it != m_SysVer.end())
    {
        return m_SysVer[sVarName];
    }
    else
    {
        cout << "���� " << sVarName << " û�ж���" << endl;
        getchar();
        return "";
    }
}


/*
* ********************************************************************
* ��������:  JudgeFun
* ����˵��:  �ж��Ƿ�Ϊϵͳ������
* д������:  2019/01/03
* ********************************************************************
*/
bool CParseScript::JudgeFun(string sFunName)
{
    // �ж��Ƿ�Ϊϵͳ������
    map<string, FUN_PTR>::iterator it = m_FunPtr.find(sFunName);
    if (it != m_FunPtr.end())
    {
        return true;
    }
    return false;
}


/*
* ********************************************************************
* ��������:  Parse_CallSysFun
* ����˵��:  ִ��ϵͳ����
* д������:  2019/01/03
* ********************************************************************
*/
string CParseScript::Parse_CallSysFun(string sFunName)
{
    string sResult = "";

    map<string, FUN_PTR>::iterator it = m_FunPtr.find(sFunName);
    if (it != m_FunPtr.end())
    {
        sResult = (*(it->second))(vParameter);
    }

    return sResult;
}


/*
* ********************************************************************
* ��������:  GetFiles
* ����˵��:  ��ȡsPath·��������txt�ļ�����
* д������:  2019/01/03
* ********************************************************************
*/
void CParseScript::GetFiles(const char *sPath, vector<string>& files)
{
#ifdef _WIN32
    //�ļ����
    long   hFile = 0;
    //�ļ���Ϣ
    struct _finddata_t fileinfo;
    string p;
    if ((hFile = _findfirst(p.assign(sPath).append("\\*").c_str(), &fileinfo)) != -1)
    {
        do
        {
            if (strcmp(fileinfo.name, ".") == 0 || strcmp(fileinfo.name, "..") == 0 || ((fileinfo.attrib &  _A_SUBDIR)))
            {
                continue;
            }
            else
            {
                //p.assign(sPath).append("\\").append(fileinfo.name);
                p.assign(fileinfo.name);
                if (p.find(".txt") == string::npos)
                {
                    continue;
                }
                files.push_back(p);
            }
        } while (_findnext(hFile, &fileinfo) == 0);
        _findclose(hFile);
    }

#else
    struct dirent * filename;
    string p;
    DIR * dir;               // return value for opendir()
    dir = opendir( sPath );
    if( NULL == dir )
    {
        cout << "Can not open dir " << sPath << endl;
        return;
    }

    /* read all the files in the dir ~ */
    while( ( filename = readdir(dir) ) != NULL )
    {
        // get rid of "." and ".."
        if(strcmp( filename->d_name , "." ) == 0 ||
            strcmp( filename->d_name , "..") == 0)
        {
            continue;
        }
        p.assign(filename->d_name);
        if (p.find(".txt") == string::npos)
        {
            continue;
        }
        files.push_back(p);
    }
    closedir(dir);
#endif
}


/*
* ********************************************************************
* ��������:  ParseLine
* ����˵��:  �������нű���
* д������:  2019/01/03
* ********************************************************************
*/
bool CParseScript::ParseLine(string sSrc, int nLine, int &nPri)
{
    if (sSrc.empty())
    {
        return false;
    }

    ScriptInfo sScriptInfo;
    sScriptInfo.nScrLine = nLine;   //����

    // ȥ������β�ո��\t
    sSrc.erase(0, sSrc.find_first_not_of(" \t\r"));
    sSrc.erase(sSrc.find_last_not_of(" \t\r") + 1);
    sSrc.erase(0, sSrc.find_first_not_of("\t\r "));
    sSrc.erase(sSrc.find_last_not_of("\t\r ") + 1);

    string::size_type loc = 0;

    // ��ȡע��
    loc = sSrc.find_first_of("//", 0);
    if (loc != string::npos)
    {
        sScriptInfo.nScrPri = nPri;
        sScriptInfo.nScrKind = Kind_Notes;
        sScriptInfo.vVerValue.push_back(sSrc.substr(loc));

        m_ScriptInfo.push_back(sScriptInfo);
        sScriptInfo.vVerValue.clear();

        // ÿ�г�ȥע�ͺ�ʣ����ַ��϶�����Ҫִ�еĽű�
        sSrc = sSrc.substr(0, loc);
    }
    if (loc == 0 || sSrc.size() == 0)
    {
        return false;
    }
    
    // ת��Ϊ��д��ĸ��˫����֮��Ĳ���ת��
    string::size_type nStart = 0;
    string::size_type nEnd = sSrc.find_first_of("\"");
    bool bStart = false;
    if (nEnd == string::npos)
    {
        transform(sSrc.begin(), sSrc.end(), sSrc.begin(), ::toupper);
    } 
    else
    {
        while (nEnd != string::npos)
        {
            if (!bStart)
            {
                transform(sSrc.begin() + nStart, sSrc.begin() + nEnd, sSrc.begin() + nStart, ::toupper);
            }
            bStart = !bStart;

            nStart = nEnd + 1;
            nEnd = sSrc.find_first_of("\"", nStart);
        }
        if (nStart < sSrc.size())
        {
            transform(sSrc.begin() + nStart, sSrc.end(), sSrc.begin() + nStart, ::toupper);
        }
    }
    
    // ȥ������β�ո��\t
    sSrc.erase(0, sSrc.find_first_not_of(" \t\r"));
    sSrc.erase(sSrc.find_last_not_of(" \t\r") + 1);
    sSrc.erase(0, sSrc.find_first_not_of("\t\r "));
    sSrc.erase(sSrc.find_last_not_of("\t\r ") + 1);
    if (sSrc.empty())
    {
        return false;
    }
        
    // ��ȡ���ͺ����ȼ�
    string sTemp = "";
    string::size_type nLen = 0;
    for (; nLen < sSrc.size(); nLen++)
    {
        sTemp += sSrc.at(nLen);

        if (sTemp == "//")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_Notes;            
            break;
        } 
        else if (sTemp == "SET ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_SetVar;
            break;
        }
        else if (sTemp == "RESET" && (nLen + 1) == sSrc.size())
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_Reset;
            break;
        }
        else if (sTemp == "MESSAGE " || sTemp == "?")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_Message;
            break;
        }
        else if (sTemp == "MESSAGE$" || sTemp == "MESSAGE\"" || sTemp == "?$" || sTemp == "?\"")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_Message;
            nLen--;
            break;
        }
        else if (sTemp == "PRINTERR ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_PrintErr;
            break;
        }
        else if (sTemp == "PRINTERR$" || sTemp == "PRINTERR\"")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_PrintErr;
            nLen--;
            break;
        }
        else if (sTemp == "LOAD_SCRIPT ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_LoadScript;
            break;
        }
        else if (sTemp == "SLEEP ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_Sleep;
            break;
        }
        else if (sTemp == "IF ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_If;
            nPri++;
            break;
        }
        else if (sTemp == "IF$" || sTemp == "IF\"")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_If;
            nPri++;
            nLen--;
            break;
        }
        else if (sTemp == "ELSEIF ")
        {
            nPri--;
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_ElseIf;
            nPri++;
            break;
        }
        else if (sTemp == "ELSEIF$" || sTemp == "ELSEIF\"")
        {
            nPri--;
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_ElseIf;
            nPri++;
            nLen--;
            break;
        }
        else if (sTemp == "ELSE")
        {
            nPri--;
            sScriptInfo.nScrPri = nPri;
            nPri++;

            //��һ���ж��Ƿ�ΪELSE IF
            string::size_type nIfPos = sSrc.find_first_of("IF");
            if (nIfPos != string::npos)
            {
                nLen = nIfPos + 2;
                sScriptInfo.nScrKind = Kind_ElseIf;
            }
            else if (nLen + 1 == sSrc.size())
            {
                sScriptInfo.nScrKind = Kind_Else;
                nLen = -1;
            }
            else
            {
                continue;
            }
            break;
        }
        else if (sTemp == "END")
        {
            //��һ���ж��Ƿ�ΪEND IF
            string::size_type nIfPos = sSrc.find_first_of("IF");
            if (nIfPos != string::npos)
            {
                nPri--;
                sScriptInfo.nScrPri = nPri;
                sScriptInfo.nScrKind = Kind_EndIf;
            }
            else if (nLen + 1 == sSrc.size())
            {
                sScriptInfo.nScrPri = nPri;
                sScriptInfo.nScrKind = Kind_End;
            }
            else
            {
                continue;
            }
            nLen = -1;
            break;
        }
        else if (sTemp == "FOR ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_For;
            nPri++;
            break;
        }
        else if (sTemp == "NEXT ")
        {
            nPri--;
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_Next;
            break;
        }
        else if (sTemp == "EXITFOR ")
        {
            nPri++;
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_ExitFor;
            nPri--;
            nLen = -1;
            break;
        }
        else if (sTemp == "HFOR ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_HFor;
            nPri++;
            break;
        }
        else if (sTemp == "HNEXT ")
        {
            nPri--;
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_HNext;
            break;
        }
        else if (sTemp == "EXITHFOR" && (nLen + 1) == sSrc.size())
        {
            nPri++;
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_ExitHFor;
            nPri--;
            nLen = -1;
            break;
        }
        else if (sTemp == "DO ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_DO;
            nPri++;
            break;
        }
        else if (sTemp == "LOOP" && (nLen + 1) == sSrc.size())
        {
            nPri--;
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_Loop;
            nLen = -1;
            break;
        }
        else if (sTemp == "CALL ")
        {
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_FunCall;
            break;
        }
        else if (sTemp == "RETURN" && (nLen + 1) == sSrc.size())
        {
            nPri--;
            sScriptInfo.nScrPri = nPri;
            sScriptInfo.nScrKind = Kind_Return;
            nLen = -1;
            break;
        }
        else if (nLen + 1 == sSrc.size())
        {
            // û���ҵ��ؼ��֣������������������
            // 1.��ֵ��AA = 112233
            // 2.��ִ����� 0084000008
            // 3.�������壬MyFun:
            if (sSrc.find('=') != string::npos)
            {
                sScriptInfo.nScrPri = nPri;
                sScriptInfo.nScrKind = Kind_SetVar;
            }
            else if (sSrc.find(':') != string::npos)
            {
                sScriptInfo.nScrPri = nPri;
                sScriptInfo.nScrKind = Kind_FunDef;
                nPri++;
            }
            else
            {
                sScriptInfo.nScrPri = nPri;
                sScriptInfo.nScrKind = Kind_Run;
            }
            nLen = -1;
            break;
        }
    }
    
    sScriptInfo.vVerValue = split(sSrc.substr(nLen + 1));    //���������е����ݣ������ض��ַ����зָ�

    //�����for��Hfor��䣬��Ҫ���⴦��һ�£����½���һ���ж����
    if (sScriptInfo.nScrKind == Kind_For ||
        sScriptInfo.nScrKind == Kind_HFor)
    {
        vector<string> vTemp;
        for (vector<string>::iterator it = sScriptInfo.vVerValue.begin(); it != sScriptInfo.vVerValue.end(); it++)
        {
            string::size_type nPos_TO = (*it).find("TO");
            string::size_type nPos_STEP = (*it).find("STEP");

            if (nPos_TO != string::npos || nPos_STEP != string::npos)
            {
                if (nPos_TO != string::npos && (*it).size() > 2)
                {
                    string sTo_0 = (*it).substr(0, nPos_TO);
                    string sTo_1 = (*it).substr(nPos_TO, 2);
                    string sTo_2 = (*it).substr(nPos_TO + 2, nPos_STEP - nPos_TO - 2);

                    if (!sTo_0.empty())
                    {
                        vTemp.push_back(sTo_0);
                    }
                    if (!sTo_1.empty())
                    {
                        vTemp.push_back(sTo_1);
                    }
                    if (!sTo_2.empty())
                    {
                        vTemp.push_back(sTo_2);
                    }
                }

                if (nPos_STEP != string::npos && (*it).size() > 4)
                {
                    string sStep_0 = (*it).substr(nPos_STEP, 4);
                    string sStep_1 = (*it).substr(nPos_STEP + 4);

                    if (!sStep_0.empty())
                    {
                        vTemp.push_back(sStep_0);
                    }
                    if (!sStep_1.empty())
                    {
                        vTemp.push_back(sStep_1);
                    }
                }

                continue;
            }

            vTemp.push_back(*it);
        }

        sScriptInfo.vVerValue = vTemp;
    }
    else if (sScriptInfo.nScrKind == Kind_LoadScript)
    {
        //Load_Script��䣬���ļ���������
        vLoadScript.push_back(sScriptInfo.vVerValue.at(1));
        return true;
    }

    m_ScriptInfo.push_back(sScriptInfo);

    return true;
}


/*
* ********************************************************************
* ��������:  ReadScript
* ����˵��:  ��ȡ�ű��ļ���
* д������:  2019/01/03
* ********************************************************************
*/
bool CParseScript::ReadScript(string sFileName)
{
    if (sFileName.empty())
    {
        return false;
    }

    //��ȡ�ļ��ı�������
    int nEncoding = GetEncodingFormat(sFileName);

    FILE *fptr = NULL;
    int nPri = 0;

    if ((fptr = fopen(sFileName.c_str(), "r")) == NULL)
    {
//        Comm.WriteRunLog("Fail to read the file : %s", sFileName.c_str());
        printf("Fail to read the file : %s", sFileName.c_str());
        return false;
    }

    int nLine = 1;

    if (nEncoding == FILE_ANSI)
    {
        char sSrc[20000] = {0};
        while(fscanf(fptr, "%[^\n]", sSrc) != EOF)
        {
            fgetc(fptr);
            string sTemp = sSrc;

            //�ַ�ת����Linux��MAC����Ҫת��Ϊ Utf8
#ifndef _WIN32
            ANSItoUTF8(sTemp);
#endif
            ParseLine(sTemp, nLine++, nPri);

            memset(sSrc, 0, sizeof(sSrc));
        }
    } 
    else if (nEncoding == FILE_UNICODE)
    {
        //Ŀǰ�����⣬��ʵ��
        return false;

        fseek(fptr, sizeof(wchar_t), 0);

        wchar_t sSrc[20000] = {0};
        while(fscanf(fptr, "%w[^\n]", sSrc) != EOF)
        {
            fgetc(fptr);

            string sTemp = "";

            //�ַ�ת����Windows����Ҫת��ΪANSI��Linux��MAC����Ҫת��Ϊ Utf8
#ifdef _WIN32
            sTemp = UNICODEtoANSI(sSrc);
#else
            sTemp = UNICODEtoUTF8(sSrc);
#endif

            ParseLine(sTemp, nLine++, nPri);

            memset(sSrc, 0, sizeof(sSrc));
        }
    }
    else if (nEncoding == FILE_UTF8)
    {
        fseek(fptr, sizeof(char) * 3, 0);

        char sSrc[20000] = {0};
        while(fscanf(fptr, "%[^\n]", sSrc) != EOF)
        {
            fgetc(fptr);

            string sTemp = sSrc;

            //�ַ�ת����Windows����Ҫת��Ϊ ANSI
#ifdef _WIN32
            UTF8toANSI(sTemp);
#endif

            ParseLine(sTemp, nLine++, nPri);

            memset(sSrc, 0, sizeof(sSrc));
        }
    }
    else
    {
        return false;
    }

    fclose(fptr);

    return true;
}


/*
* ********************************************************************
* ��������:  CheckScript
* ����˵��:  У���ȡ�Ľű��Ƿ�Ϸ���
* д������:  2019/01/03
* ********************************************************************
*/
bool CParseScript::CheckScript()
{
    if (m_ScriptInfo.empty())
    {
        return false;
    }

    //ͨ�����ȼ�У��ű��Ƿ���ȷ��
    //��Ҫ��if��endif�Ƿ�ƥ�䣬for��next�Ƿ�ƥ�䣬do��loop�Ƿ�ƥ�䣬���������ֵ�����ȡ��m_FunInfo
    list<int> pPri;
    for (VCT_SCRIPTINFO::iterator it = m_ScriptInfo.begin(); it != m_ScriptInfo.end(); )
    {
        //�������¼������ͣ�˵��Ҫ����ĳ�����̣�����һ�¸��Ե����ȼ�
        if (it->nScrKind == Kind_If ||
            it->nScrKind == Kind_DO ||
            it->nScrKind == Kind_For ||
            it->nScrKind == Kind_HFor)
        {
            pPri.push_back(it->nScrPri);
            it++;
            continue;
        }

        //�������¼������ͣ������ȼ���pPri���һ��Ԫ����ͬ����ʾƥ��
        if ((it->nScrKind == Kind_EndIf ||
            it->nScrKind == Kind_Loop ||
            it->nScrKind == Kind_Next ||
            it->nScrKind == Kind_HNext) &&
            (!pPri.empty() && it->nScrPri == pPri.back()))
        {
            pPri.pop_back();
            it++;
            continue;
        }

        //����Ǻ������壬�����±��浽m_FunInfo
        if (it->nScrKind == Kind_FunDef)
        {
            int nTemp = it->nScrPri;

            FunInfo mFun;
            mFun.sFunName = it->vVerValue.at(0);

            it = m_ScriptInfo.erase(it);
            while (it != m_ScriptInfo.end())
            {
                if (it->nScrKind == Kind_Return &&
                    nTemp == it->nScrPri)
                {
                    it = m_ScriptInfo.erase(it);
                    break;
                }
                mFun.vScriptInfo.push_back(*it);

                it = m_ScriptInfo.erase(it);
            }

            m_FunInfo.push_back(mFun);
        }
        else
        {
            it++;
        }
    }

    //У�飬����������̾���ȫƥ�䣬��pPriӦ��Ϊ��
    if (pPri.empty())
    {
        return true;
    }
    else
    {
        return false;
    }
}


/*
* ********************************************************************
* ��������:  RunScript
* ����˵��:  ���������ű���
* д������:  2019/01/03
* ********************************************************************
*/
bool CParseScript::RunScript()
{
    for (VCT_SCRIPTINFO::iterator it = m_ScriptInfo.begin(); it != m_ScriptInfo.end(); it++)
    {
        if (it->nScrKind == Kind_End)
        {
            break;
        }
        if (it->nScrKind == Kind_Reset)
        {
            Reader_CosClose(SCARD_RESET_CARD);
            Reader_CosOpen(SCARD_PROTOCOL_T0|SCARD_PROTOCOL_T1, m_ReadName.c_str());
            continue;
        }
        RunLine(it, m_ScriptInfo.end());
    }

    return true;
}


/*
* ********************************************************************
* ��������:  RunLine
* ����˵��:  ִ�е��нű���
* д������:  2019/01/03
* ********************************************************************
*/
bool CParseScript::RunLine(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd)
{
    bool bEnd = true;

    switch (it->nScrKind)
    {
    case Kind_Message:
        Parse_Message(it->vVerValue);
        break;
    case Kind_PrintErr:
        Parse_PrintErr(it->nScrLine, it->vVerValue);
        break;
    case Kind_Sleep:
        SYS_Sleep(it->vVerValue);
        break;
    case Kind_SetVar:
        Parse_Set(it->vVerValue);
        break;
    case Kind_If:
        bEnd = Parse_IF(it, itEnd);
        break;
    case Kind_For:
    case Kind_HFor:
    case Kind_DO:
        Parse_For(it, itEnd);
        break;
    case Kind_FunCall:
        Parse_Call(it->vVerValue);
        break;
    case Kind_Run:
        Parse_Run(it->vVerValue);
        break;
    }
    return bEnd;
}


/*
* ********************************************************************
* ��������:  Parse_Operator
* ����˵��:  �������ʽ���
* д������:  2019/01/03
* ********************************************************************
*/
bool CParseScript::Parse_Operator(vector<string> vScript)
{
    string sLeft = "";
    string sRight = "";
    int nLeft = 0;
    int nRight = 0;
    string sTemp = "";
    string sOP = "";
    bool isTrue = false;

    for (vector<string>::iterator it = vScript.begin(); it != vScript.end(); it++)
    {
        if (*it == "$")
        {
            it++;
            if (it != vScript.end())
            {
                sTemp += GetVarValue(*it);
            }
        }
        else if (*it == "SW" || *it == "RESULT")
        {
            sTemp += GetVarValue(*it);
        }
        else if (*it == "<" ||
            *it == ">" ||
            *it == "!" ||
            *it == "=")
        {
            //������һ��������ʱ����ȡ��ֵ
            if (sOP.empty())
            {
                sLeft = sTemp;
                sTemp = "";
            }

            sOP += (*it);
        }
        else
        {
            sTemp += (*it);
        }
    }

    sRight = sTemp;

    //�������ͬ�ĳ���
    nLeft = sLeft.length();
    nRight = sRight.length();

    if (nLeft > nRight)
    {
        string s = "";
        s.append(nLeft - nRight, '0');
        sRight = s + sRight;
    }
    else
    {
        string s = "";
        s.append(nRight - nLeft, '0');
        sLeft = s + sLeft;
    }

    //�Ƚ�
    if (sOP == "<")
    {
        isTrue = (sLeft < sRight);
    }
    else if (sOP == ">")
    {
        isTrue = (sLeft > sRight);
    }
    else if (sOP == "<=")
    {
        isTrue = (sLeft <= sRight);
    }
    else if (sOP == ">=")
    {
        isTrue = (sLeft >= sRight);
    }
    else if (sOP == "==")
    {
        isTrue = (sLeft == sRight);
    }
    else if (sOP == "!=")
    {
        isTrue = (sLeft != sRight);
    }
    else
    {
        isTrue = false;
    }

    return isTrue;
}


/*
* ********************************************************************
* ��������:  Parse_Message
* ����˵��:  ����Message���
* д������:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_Message(vector<string> vScript)
{
    string sTemp = "";

    int nStart = 0;
    int nEnd = 0;

    //˫�����ڲ��ı���������Ҫת���������ַ�����ӡ
    bool isShow = true;
    for (vector<string>::iterator it = vScript.begin(); it != vScript.end(); it++)
    {
        if (*it == "\"")
        {
            isShow = !isShow;
            continue;
        }

        if (*it == "$" && isShow)
        {
            it++;
            sTemp += GetVarValue(*it);
        }
        else
        {
            sTemp += *it;
        }
    }
    cout << "Message: " << sTemp << endl;
//    Comm.WriteRunLog("Message: %s", sTemp.c_str());
    printf("Message: %s", sTemp.c_str());

    return;
}


/*
* ********************************************************************
* ��������:  Parse_PrintErr
* ����˵��:  ����PrintErr���
* д������:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_PrintErr(int nLine, vector<string> vScript)
{
    string sTemp = "";

    int nStart = 0;
    int nEnd = 0;

    //˫�����ڲ��ı���������Ҫת���������ַ�����ӡ
    bool isShow = true;
    for (vector<string>::iterator it = vScript.begin(); it != vScript.end(); it++)
    {
        if (*it == "\"")
        {
            isShow = !isShow;
            continue;
        }

        if (*it == "$" && isShow)
        {
            it++;
            sTemp += GetVarValue(*it);
        }
        else
        {
            sTemp += *it;
        }
    }
    //Comm.WriteBugInfo(POSITION, "%s", sTemp.c_str());
//    Comm.WriteBugInfo(NULL, NULL, nLine, "%s", sTemp.c_str());
    printf("Line:%d, %s", nLine, sTemp.c_str());
    return;
}


/*
* ********************************************************************
* ��������:  Parse_Set
* ����˵��:  ����Set���
* д������:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_Set(vector<string> vScript)
{
    // ���ֻ��һ���ڵ㣬˵���ű���ʽΪ set AA��Ĭ�Ϸ���RESULT��ֵ
    if (vScript.size() == 1)
    {
        SetVarValue(vScript.at(0), GetVarValue("RESULT"));
//        Comm.WriteRunLog("Set %s = %s", vScript.at(0).c_str(), GetVarValue("RESULT").c_str());
        printf("Set %s = %s", vScript.at(0).c_str(), GetVarValue("RESULT").c_str());
        return;
    }

    string sTemp = "";

    // ��ʽ����Ϊ��
    //      AA = 112233         �̶��ַ���
    //      AA = "112233"       �̶��ַ�������Ҫת����31 31 32 32 33 33
    //      BB = $AA            ������ֵ
    //      BB = (1122)         ������ֵ��ȡ���ȣ����Ϊ02 1122
    //      BB = $AA 112233     �̶��ַ��� �� ����
    //      BB = add(01,02)     �������ĺ�������
    //      BB = rand           ���������ĺ�������
    bool bStart = false;
    for (vector<string>::iterator it = vScript.begin(); it != vScript.end(); it++)
    {
        if (it == vScript.begin())
        {
            it++;
            continue;
        }

        if (*it == ")" || 
            *it == ">" || 
            *it == "}")
        {
            continue;
        }
        else if (*it == "$")
        {
            //��һ���ڵ��ʾ����������ȡ����ֵ
            it++;
            sTemp += GetVarValue(*it);
        }
        else if (*it == "\"")
        {
            it++;
            while (it != vScript.end())
            {
                if (*it == "\"")
                {
                    break;
                }
                for (string::size_type i = 0; i != (*it).size(); ++i)
                {
                    char hex[5];
                    sprintf(hex, "%02X", (unsigned char)(*it).at(i));
                    sTemp += hex;
                }
                it++;
            }
        }
        else if (*it == "(")
        {
            //�ߵ���һ����˵������Ҫ()�ڲ����ݵĳ���
            it++;
            int nLen = 0;

            if ((it + 1) != vScript.end() && *(it + 1) == ")")
            {
                char sLen[10] = { 0 };

                nLen = (*it).length() / 2;
                sprintf(sLen, "%02X", nLen);
                sTemp += (string(sLen) + (*it));
            }
            it++;
        }
        else if (*it == "<")
        {
            //�ߵ���һ����˵������Ҫ<>�ڲ����ݵĳ���
            it++;
            int nLen = 0;

            if ((it + 1) != vScript.end() && *(it + 1) == ">")
            {
                char sLen[10] = { 0 };

                nLen = (*it).length() / 2 + 4;
                sprintf(sLen, "%02X", nLen);
                sTemp += (string(sLen) + (*it));
            }
            it++;
        }
        else if (*it == "{")
        {
            //�ߵ���һ����˵������Ҫ<>�ڲ����ݵĳ���
            it++;
            int nLen = 0;

            if ((it + 1) != vScript.end() && *(it + 1) == "}")
            {
                char sLen[10] = { 0 };

                nLen = (*it).length() / 2;
                sprintf(sLen, "%06X", nLen);
                sTemp += (string(sLen) + (*it));
            }
            it++;
        }
        else
        {
            //����һ�������ַ��������Ǻ�������Ҳ�����ǳ����ַ�
            //����set�����Ĺ��ɣ�����Ǻ�������������Ȼ����()
            //������ǳ����ַ���
            if (JudgeFun(*it))
            {
                string sFunName = *it;
                if (sFunName == "POP")
                {
                    sTemp += vParameter.back();
                    vParameter.pop_back();
                    break;
                }

                string sParameter = "";
                vParameter.clear();

                //��������������Ǻ������ã�����snooper������ֻ֧��һ���������ʽ
                while ((it + 1) != vScript.end())
                {
                    it++;

                    if (*it == "(")
                    {
                        sParameter = "";
                    }
                    else if (*it == ",")
                    {
                        vParameter.push_back(sParameter);
                        sParameter = "";
                    }
                    else if (*it == ")")
                    {
                        vParameter.push_back(sParameter);
                        sParameter = "";
                        break;
                    }
                    else if (*it == "$")
                    {
                        it++;
                        sParameter += GetVarValue(*it);
                    }
                    else if (*it == "\"")
                    {
                        //����˫���ţ���ȡ֮�������
                        if (!bStart)
                        {
                            it++;
                            sParameter += (*it);
                        }

                        bStart = !bStart;
                    }
                    else
                    {
                        sParameter += (*it);
                    }
                }

                //ִ��ϵͳ����
                sTemp += Parse_CallSysFun(sFunName);
            } 
            else
            {
                //���ַ�����ֱ�������Ͼ�����
                sTemp += (*it);
            }
        }        
    }

    SetVarValue(vScript.at(0), sTemp);
//    Comm.WriteRunLog("Set %s = %s", vScript.at(0).c_str(), sTemp.c_str());
    printf("Set %s = %s", vScript.at(0).c_str(), sTemp.c_str());
}


/*
* ********************************************************************
* ��������:  Parse_IF
* ����˵��:  ����ifģ�飬ֱ��ͬ����end if�����֡�
* д������:  2019/01/03
* ********************************************************************
*/
bool CParseScript::Parse_IF(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd)
{
    //�Ƿ�����ִ�е�����
    bool bEnd = true;

    //����һ��if�������ȼ�
    int nPri = it->nScrPri;

    //if����else if����Ƿ�ִ�й�
    //���ִ�й�����������е�if��else if������ִ��
    bool isInProcess = false;

    while (true)
    {
        //�������end if����Ҫ�ж����ȼ��Ƿ��if��һ�¡��ò�����Ϊ��if�ڲ��Ƕ��
        if (it->nScrKind == Kind_EndIf)
        {
            if (it->nScrPri == nPri)
            {
                // ֻ�����ȼ���ͬ���ű�ʾifģ�������
                break;
            }
            if ((it++) == itEnd)
            {
                break;
            }
        }
        if (it->nScrKind == Kind_End ||
            it->nScrKind == Kind_Return)
        {
            break;
        }

        //if��else ifģ�飬��������֤��ͬ
        if (it->nScrKind == Kind_If || it->nScrKind == Kind_ElseIf)
        {
            //�ж�if�ı��ʽ�Ƿ�Ϊ��
            bool bIfResult = Parse_Operator(it->vVerValue);

            //��ִ��ifģ�����е�ָ��
            while ((it++) != itEnd)
            {
                if (it->nScrKind == Kind_ElseIf ||
                    it->nScrKind == Kind_Else ||
                    it->nScrKind == Kind_EndIf)
                {
                    break;
                }
                if (it->nScrKind == Kind_End ||
                    it->nScrKind == Kind_Return)
                {
                    return bEnd;
                }

                if (bIfResult && !isInProcess)
                {
                    //���ifģ����forѭ����Ƕ�ף�������exit for���˳�
                    if (it->nScrKind == Kind_ExitFor ||
                        it->nScrKind == Kind_ExitHFor)
                    {
                        bEnd = false;
                        break;
                    }
                    RunLine(it, itEnd);
                }
            }

            //���if���ʽΪ�棬��û��ִ�й�if��else ifģ�飬��isInProcess��Ϊtrue���Դ�ֻ��ִ֤��һ��if��else if
            if (bIfResult && !isInProcess)
            {
                isInProcess = true;
            }
        }

        //elseģ��
        if (it->nScrKind == Kind_Else)
        {
            while ((it++) != itEnd)
            {
                //�ߵ��������ֻ�ܸ�end if����ƥ��
                if (it->nScrKind == Kind_EndIf)
                {
                    break;
                }
                if (it->nScrKind == Kind_End ||
                    it->nScrKind == Kind_Return)
                {
                    return bEnd;
                }

                //���if��else if��û��ִ�У���ִ��else�����ָ��
                if (!isInProcess)
                {
                    //���ifģ����forѭ����Ƕ�ף�������exit for���˳�
                    if (it->nScrKind == Kind_ExitFor ||
                        it->nScrKind == Kind_ExitHFor)
                    {
                        bEnd = false;
                        break;
                    }
                    RunLine(it, itEnd);
                }
            }
        }
    }

    return bEnd;
}


/*
* ********************************************************************
* ��������:  Parse_For
* ����˵��:  ����for��hforģ�飬ֱ��ѭ��������
* д������:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_For(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd)
{
    //����һ��for�������ȼ�
    int nPri = it->nScrPri;

    //for������ʼλ�ú���ֹλ��
    VCT_SCRIPTINFO::iterator it_ForBegin    = it;
    VCT_SCRIPTINFO::iterator it_ForEnd      = it;

    //forģ���µ�����Ƿ�Ӧ��ִ�С��������exit for���������䶼����ִ��
    bool isInProcess = true;

    //*********************************�����������*********************************//
    string sName = "";  //�α�����
    int nFlag = 0;      //�α��С
    int nBegin  = 0;    //��ʼֵ
    int nEnd    = 0;    //����ֵ
    int nStep   = 1;    //ѭ���Ĳ�����Ĭ����1
    int nFormats = 10;  //����

    if (it->nScrKind == Kind_DO)
    {
        //do  loopѭ������ʽΪdo 20000
        sName = "DO_Loop_";
        char s[5] = { 0 };
        sprintf(s, "%02X", nPri);
        sName += s;
        if (it->vVerValue.at(0) == "$")
        {
            nEnd = strtol(GetVarValue(it->vVerValue.at(1)).c_str(), NULL, 10);
        }
        else
        {
            nEnd = strtol(it->vVerValue.at(0).c_str(), NULL, 10);
        }
        
        SetVarValue(sName, "00");
    } 
    else
    {
        //for��Hforѭ��
        if (it->vVerValue.size() < 5)
        {
            cout << "For ��������ο���ʽ��for ���ʽ1 = ���ʽ2 to ���ʽ3 step ���ʽ4" << endl;
            return;
        }

        sName = it->vVerValue.at(0);
        
        if (it->nScrKind == Kind_For)
        {
            //For������Ϊ10����
            nFormats = 10;
        }
        else
        {
            //HFor������Ϊ16����
            nFormats = 16;
        }

        string::size_type i = 0;
        while (i < it->vVerValue.size())
        {
            if (it->vVerValue.at(i) == "=")
            {
                i++;
                if (it->vVerValue.at(i) == "$")
                {
                    i++;
                    nBegin = strtol(GetVarValue(it->vVerValue.at(i)).c_str(), NULL, nFormats);
                }
                else
                {
                    nBegin = strtol(it->vVerValue.at(i).c_str(), NULL, nFormats);
                }
            }
            else if (it->vVerValue.at(i) == "TO")
            {
                i++;
                if (it->vVerValue.at(i) == "$")
                {
                    i++;
                    nEnd = strtol(GetVarValue(it->vVerValue.at(i)).c_str(), NULL, nFormats);
                }
                else
                {
                    nEnd = strtol(it->vVerValue.at(i).c_str(), NULL, nFormats);
                }
            }
            else if (it->vVerValue.at(i) == "STEP")
            {
                i++;
                if (it->vVerValue.at(i) == "$")
                {
                    i++;
                    nStep = strtol(GetVarValue(it->vVerValue.at(i)).c_str(), NULL, nFormats);
                }
                else
                {
                    nStep = strtol(it->vVerValue.at(i).c_str(), NULL, nFormats);
                }
            }
            else
            {
                i++;
            }
        }
        
        //���µ�ȫ�ֱ���
        SetVarValue(sName, it->vVerValue.at(2));
    }    

    //*********************************ִ��ѭ�����*********************************//
    while (true)
    {
        it = it_ForBegin;

        while ((it++) != itEnd)
        {
            if (it->nScrKind == Kind_ExitFor ||
                it->nScrKind == Kind_ExitHFor)
            {
                //���˳�ѭ������������next
                isInProcess = false;
            }
            if (it->nScrKind == Kind_End ||
                it->nScrKind == Kind_Return)
            {
                return;
            }
            if (it->nScrKind == Kind_Next ||
                it->nScrKind == Kind_HNext ||
                it->nScrKind == Kind_Loop)
            {
                if (it->nScrPri == nPri)
                {
                    // ֻ�����ȼ���ͬ���ű�ʾforģ�������
                    it_ForEnd = it;
                    break;
                }
            }
            
            //�����;����exit for���������䲻����ִ��
            if (isInProcess)
            {
                if (!RunLine(it, itEnd))
                {
                    isInProcess = false;
                }
            }
        }
        
        //�ж��Ƿ�Ӧ���˳�forѭ����ϵͳ������ֻ�洢16���Ƶ���
        nFlag = strtol(GetVarValue(sName).c_str(), NULL, 16);
        nFlag += nStep;

        //����snooperд�������⣬��ʽΪ��for a = 0 to 5������Ϊ[0, 5]����ʽΪ��do 5������Ϊ[0, 5)��Ϊ�˼���snooper�����Ե����⴦��һ��
        if (it_ForBegin->nScrKind == Kind_DO)
        {
            if ((nEnd - 1) <= 0 || nFlag == nEnd)
            {
                break;
            }
        }
        else
        {
            if ((nStep > 0 && nFlag > nEnd) ||
                (nStep < 0 && nFlag < nEnd))
            {
                break;
            }
        }
        
        char sNum[100] = { 0 };
        sprintf(sNum, "%02X", nFlag);
        SetVarValue(sName, sNum);
    }

    // ��itָ��next����һ���ڵ�
    it = it_ForEnd++;
}


/*
* ********************************************************************
* ��������:  Parse_Call
* ����˵��:  �����Զ���ĺ�����
* д������:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_Call(vector<string> vScript)
{
    string sFunName = "";
    vParameter.clear();

    //�Ƚ����������Ͳ���
    string sParameter = "";
    for (vector<string>::iterator it = vScript.begin(); it != vScript.end(); it++)
    {
        if (it == vScript.begin())
        {
            sFunName = *it;
            continue;
        }

        if (*it == "(")
        {
            sParameter = "";
        }
        else if (*it == ",")
        {
            vParameter.push_back(sParameter);
            sParameter = "";
        }
        else if (*it == ")")
        {
            vParameter.push_back(sParameter);
            sParameter = "";
            break;
        }
        else if (*it == "$")
        {
            it++;
            sParameter = GetVarValue(*it);
        }
        else
        {
            sParameter += (*it);
        }
    }

    //���һ���ĺ����б�ִ�к���
    for (VCT_FUNINFO::iterator itFun = m_FunInfo.begin(); itFun != m_FunInfo.end(); itFun++)
    {
        if (itFun->sFunName != sFunName)
        {
            continue;
        }
        
        for (VCT_SCRIPTINFO::iterator it = itFun->vScriptInfo.begin(); it != itFun->vScriptInfo.end(); it++)
        {
            RunLine(it, itFun->vScriptInfo.end());
        }
    }
}


/*
* ********************************************************************
* ��������:  Parse_Run
* ����˵��:  ��Ҫִ�еĽű���
* д������:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_Run(vector<string> vScript)
{
    if (vScript.at(0) == "CLEAR")
    {
    }
    else if (vScript.at(0) == "PAUSE")
    {
        printf("Pauth, �밴���������...");
        getchar();
    }
    else if (vScript.at(0) == "TIMER_BEGIN")
    {
//        Comm.WriteRunLog("��ʼ��ʱ...");
        printf("��ʼ��ʱ...");
        m_bTime = true;
        m_Time = 0;
    }
    else if (vScript.at(0) == "TIMER_END")
    {
        int nFlag = strtol(GetVarValue("PERFORMANCETIMES").c_str(), NULL, 16);
        m_bTime = false;
//        Comm.WriteRunLog("������ʱ�����д���%d��ƽ����ʱ %.3f ms", nFlag, (double)(m_Time / nFlag));
        printf("������ʱ�����д���%d��ƽ����ʱ %.3f ms", nFlag, (double)(m_Time / nFlag));
    }
    else
    {
        string sAPDU = "";
        for (vector<string>::iterator it = vScript.begin(); it != vScript.end(); it++)
        {
            if (*it == ")" || 
                *it == ">" || 
                *it == "}")
            {
                continue;
            }
            else if (*it == "$")
            {
                it++;
                sAPDU += GetVarValue(*it);
            }
            else if (*it == "(" || *it == "{")
            {
                //�ߵ���һ����˵������Ҫ()�ڲ����ݵĳ���
                it++;
                string sTemp = "";
                while (true)
                {
                    if ((it + 1) == vScript.end() || *(it + 1) == ")" || *(it + 1) == "}")
                    {
                        break;
                    }
                    if (*it == "$")
                    {
                        it++;
                        sTemp += GetVarValue(*it);
                    }
                    else
                    {
                        sTemp += *it;
                    }
                    it++;
                }
                char sLen[10] = { 0 };
                if (sTemp.length() / 2 > 0xFF)
                {
                    sprintf(sLen, "%06X", (WORD)(sTemp.length() / 2));
                }
                else
                {
                    sprintf(sLen, "%02X", (WORD)(sTemp.length() / 2));
                }                
                sAPDU += (string(sLen) + sTemp);

                it++;
            }
            else
            {
                sAPDU += *it;
            }
        }

        BYTE pbApdu[20 * 1024] = { 0 };
        int nApduLen = sAPDU.length() / 2;
        BYTE pbRecv[20 * 1024] = { 0 };
        DWORD dwRecvLen = 20 * 1024;

        HexStrToByte(sAPDU.c_str(), pbApdu, &nApduLen);

//        Comm.WriteRunLog("--> %s", sAPDU.c_str());
        printf("--> %s", sAPDU.c_str());
        cout << endl << sAPDU << endl;

        if (m_bTime)
        {
//            DWORD dwTimeBegin = (DWORD)Comm.GetCurrentTimeMsec();
//            m_Cos.FT_Transmit(&m_Card, pbApdu, nApduLen, pbRecv, &dwRecvLen);
//            DWORD dwTimeEnd = (DWORD)Comm.GetCurrentTimeMsec();
//            m_Time += (dwTimeEnd - dwTimeBegin);
            Reader_Transmit(pbApdu, nApduLen, pbRecv, &dwRecvLen);
        }
        else
        {
//            m_Cos.FT_Transmit(&m_Card, pbApdu, nApduLen, pbRecv, &dwRecvLen);
            ULONG ret = Reader_Transmit(pbApdu, nApduLen, pbRecv, &dwRecvLen);
            printf("%d", ret);
        }
        
        //�洢���
        SetVarValue("SW", Byte2Hex(pbRecv + dwRecvLen - 2, 2));
        SetVarValue("RESULT", Byte2Hex(pbRecv, dwRecvLen - 2));

        //��ӡ���
        if (dwRecvLen > 2)
        {
//            Comm.WriteRunLog("<-- %s", GetVarValue("RESULT").c_str());
            printf("<-- %s", GetVarValue("RESULT").c_str());
            cout << GetVarValue("RESULT") << endl;
        }

//        Comm.WriteRunLog("<-- %s", GetVarValue("SW").c_str());
        printf("<-- %s", GetVarValue("SW").c_str());
        cout << GetVarValue("SW") << endl;
    }
}


/*
* ********************************************************************
* ��������:  Reader_Enum
* ����˵��:  ö�ٶ�������
* д������:  2019/01/03
* ********************************************************************
*/
int CParseScript::Reader_Enum(char reader_list[][256])
{
//    return m_Cos.FT_EnumReader(reader_list);
    char mszReaders[128] = "";
    DWORD pcchReaders = -1;
    
    ULONG ret = SCardListReaders(gContxtHandle, NULL, mszReaders, &pcchReaders);
    if (ret != SCARD_S_SUCCESS) {
        return ret;
    }
    
    return ret;
//    for (int i = 0; i < pcchReaders; i++) {
//        memcpy(&reader_list[i], mszReaders, <#size_t __n#>)
//    }
}


/*
* ********************************************************************
* ��������:  Reader_CosOpen
* ����˵��:  ��ָ���Ķ������������ӿ�Ƭ��
* д������:  2019/01/03
* ********************************************************************
*/
LONG CParseScript::Reader_CosOpen(DWORD dwpreferredprotocal, string reader_name)
{
//    return m_Cos.FT_CosOpen(&m_Card, dwpreferredprotocal, (char*)reader_name.c_str());
    DWORD dwActiveProtocol = -1;
    return SCardConnect(gContxtHandle, reader_name.c_str(), SCARD_SHARE_SHARED, SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1, &m_card, &dwActiveProtocol);
}


/*
* ********************************************************************
* ��������:  Reader_CosClose
* ����˵��:  �ر����ӡ�
* д������:  2019/01/03
* ********************************************************************
*/
LONG CParseScript::Reader_CosClose(DWORD scd)
{
//    return m_Cos.FT_CosClose(&m_Card, scd);
    return SCardDisconnect(m_card, SCARD_UNPOWER_CARD);
}


/*
* ********************************************************************
* ��������:  Reader_SCardReleaseContext
* ����˵��:  �ͷ������ġ�
* д������:  2019/01/03
* ********************************************************************
*/
LONG CParseScript::Reader_SCardReleaseContext()
{
//    return m_Cos.FT_SCardReleaseContext();
    return SCardReleaseContext(gContxtHandle);
}


/*
* ********************************************************************
* ��������:  Reader_Transmit
* ����˵��:  ��ָ���Ķ���������COS���
* д������:  2019/01/03
* ********************************************************************
*/
LONG CParseScript::Reader_Transmit(BYTE *pbApdu, int apdulen, BYTE *recv, DWORD * retlen)
{
    //    return m_Cos.FT_Transmit(&m_Card, pbApdu, apdulen, recv, retlen);
    SCARD_IO_REQUEST pioSendPci;
    return SCardTransmit(gCardHandle, &pioSendPci, (unsigned char*)pbApdu, apdulen, NULL, (LPBYTE)recv, (LPDWORD)retlen);
}
