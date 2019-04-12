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

//UTF8转ANSI
void UTF8toANSI(string &strUTF8)
{
#ifdef _WIN32
    //获取转换为多字节后需要的缓冲区大小，创建多字节缓冲区
    int nLen = MultiByteToWideChar(CP_UTF8, NULL, strUTF8.c_str(), -1, NULL, NULL);
    wchar_t *wszBuffer = new wchar_t[nLen + 1];
    nLen = MultiByteToWideChar(CP_UTF8, NULL, strUTF8.c_str(), -1, wszBuffer, nLen);
    wszBuffer[nLen] = 0;

    nLen = WideCharToMultiByte(936, NULL, wszBuffer, -1, NULL, NULL, NULL, NULL);
    char *szBuffer = new char[nLen + 1];
    nLen = WideCharToMultiByte(936, NULL, wszBuffer, -1, szBuffer, nLen, NULL, NULL);
    szBuffer[nLen] = 0;

    strUTF8 = szBuffer;
    //清理内存
    delete[]szBuffer;
    delete[]wszBuffer;
    szBuffer = NULL;
    wszBuffer = NULL;
#endif
}

//ANSI转UTF8
void ANSItoUTF8(string &strAnsi)
{
#ifdef _WIN32
    //获取转换为宽字节后需要的缓冲区大小，创建宽字节缓冲区，936为简体中文GB2312代码页
    int nLen = MultiByteToWideChar(936,NULL,strAnsi.c_str(),-1,NULL,NULL);
    wchar_t *wszBuffer = new wchar_t[nLen+1];
    nLen = MultiByteToWideChar(936,NULL,strAnsi.c_str(),-1,wszBuffer,nLen);
    wszBuffer[nLen] = 0;
    //获取转为UTF8多字节后需要的缓冲区大小，创建多字节缓冲区
    nLen = WideCharToMultiByte(CP_UTF8,NULL,wszBuffer,-1,NULL,NULL,NULL,NULL);
    char *szBuffer = new char[nLen+1];
    nLen = WideCharToMultiByte(CP_UTF8,NULL,wszBuffer,-1,szBuffer,nLen,NULL,NULL);
    szBuffer[nLen] = 0;

    strAnsi = szBuffer;
    //内存清理
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
    char* srcStart = (char*)strAnsi.c_str();// srcBuffer同样可以是wchar_t，这里也是这样强制转换
    size_t nStart = strAnsi.length();
    size_t nResult = 0;
    char* tempOutBuffer = s_outbuffer;//要有这个临时变量，否则iconv会直接改写s_outbuffer指针
    size_t ret = iconv(cd, (char**)&srcStart, &nStart, &tempOutBuffer, &nResult);
    iconv_close(cd);
#endif
}

//UNICODE转ANSI
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

//UNICODE转UTF8
string UNICODEtoUTF8(wchar_t* str)
{
    string strUnicode = "";
#ifdef _WIN32
#else
    iconv_t cd;
    cd = iconv_open("UTF-8", "WCHAR_T");  //WCHAR_T即unicode
    if (cd == 0) return "";

    int inBytes = wcslen(str) * sizeof(wchar_t);
    int outBytes = 6 * wcslen(str) ; // 6为utf-8的一个字符的最大字节数
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


//判断脚本文件的编码格式
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

    //系统变量
    m_SysVer.insert(pair<string, string>("SW", ""));                    //返回的SW
    m_SysVer.insert(pair<string, string>("RESULT", ""));                //apdu缓存返回值
    m_SysVer.insert(pair<string, string>("PERFORMANCETIMES", "0A"));    //性能次数，默认10次

    //系统函数名和指针
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
* 函数名称:  HexStrToByte
* 函数说明:  十六进制字符串转换为字节流
* 写作日期:  2019/01/03
* ********************************************************************
*/
void HexStrToByte(const char* source, BYTE* dest, int *destLen)
{
    short i;
    BYTE highByte, lowByte;

    char sTemp[10000] = { 0 };
    int sTempLen = 0;

    //删除所有空格
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
* 函数名称:  Byte2Hex
* 函数说明:  字节流转换成十六进制字符串
* 写作日期:  2019/01/03
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
* 函数名称:  split
* 函数说明:  分割字符串，sSeperator可以输入多个分隔符。返回分割之后的vector
* 写作日期:  2019/01/03
* ********************************************************************
*/
vector<string> CParseScript::split(const string &sSrc, const string &sSeperator)
{
    vector<string> result;
    typedef string::size_type string_size;
    string_size i = 0;

    while (i != sSrc.size())
    {
        //找到字符串中首个不等于分隔符的字母；
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

        //找到又一个分隔符，将两个分隔符之间的字符串取出；
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

            //如果前一个元素是$，则需要按照空格或者]再分割一次
            if (!result.empty() && result.back() == "$")
            {
                //查找是否有[]
                string::size_type nPos = sTemp.find_first_of("]");
                if (nPos != string::npos)
                {
                    sLeft = sTemp.substr(0, nPos + 1);
                    sRight = sTemp.substr(nPos + 1);

                    //删除空格和\t
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
                    //没有[]，则查找空格
                    nPos = sTemp.find_first_of(" ");
                    if (nPos != string::npos)
                    {
                        sLeft = sTemp.substr(0, nPos);
                        sRight = sTemp.substr(nPos);

                        //删除空格和\t
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
                //删除空格和\t，并加入vector
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
* 函数名称:  SetVarValue
* 函数说明:  设置系统变量。sVarName：变量名。sVarValue：变量内容
* 写作日期:  2019/01/03
* ********************************************************************
*/
void CParseScript::SetVarValue(string sVarName, string sVarValue)
{
    //补齐成2的整数倍长度
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
* 函数名称:  GetVarValue
* 函数说明:  获取系统变量。sVarName：变量名
* 写作日期:  2019/01/03
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
        cout << "变量 " << sVarName << " 没有定义" << endl;
        getchar();
        return "";
    }
}


/*
* ********************************************************************
* 函数名称:  JudgeFun
* 函数说明:  判断是否为系统函数名
* 写作日期:  2019/01/03
* ********************************************************************
*/
bool CParseScript::JudgeFun(string sFunName)
{
    // 判断是否为系统函数名
    map<string, FUN_PTR>::iterator it = m_FunPtr.find(sFunName);
    if (it != m_FunPtr.end())
    {
        return true;
    }
    return false;
}


/*
* ********************************************************************
* 函数名称:  Parse_CallSysFun
* 函数说明:  执行系统函数
* 写作日期:  2019/01/03
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
* 函数名称:  GetFiles
* 函数说明:  获取sPath路径下所有txt文件名称
* 写作日期:  2019/01/03
* ********************************************************************
*/
void CParseScript::GetFiles(const char *sPath, vector<string>& files)
{
#ifdef _WIN32
    //文件句柄
    long   hFile = 0;
    //文件信息
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
* 函数名称:  ParseLine
* 函数说明:  解析单行脚本。
* 写作日期:  2019/01/03
* ********************************************************************
*/
bool CParseScript::ParseLine(string sSrc, int nLine, int &nPri)
{
    if (sSrc.empty())
    {
        return false;
    }

    ScriptInfo sScriptInfo;
    sScriptInfo.nScrLine = nLine;   //行数

    // 去除行首尾空格和\t
    sSrc.erase(0, sSrc.find_first_not_of(" \t\r"));
    sSrc.erase(sSrc.find_last_not_of(" \t\r") + 1);
    sSrc.erase(0, sSrc.find_first_not_of("\t\r "));
    sSrc.erase(sSrc.find_last_not_of("\t\r ") + 1);

    string::size_type loc = 0;

    // 截取注释
    loc = sSrc.find_first_of("//", 0);
    if (loc != string::npos)
    {
        sScriptInfo.nScrPri = nPri;
        sScriptInfo.nScrKind = Kind_Notes;
        sScriptInfo.vVerValue.push_back(sSrc.substr(loc));

        m_ScriptInfo.push_back(sScriptInfo);
        sScriptInfo.vVerValue.clear();

        // 每行除去注释后，剩余的字符肯定是需要执行的脚本
        sSrc = sSrc.substr(0, loc);
    }
    if (loc == 0 || sSrc.size() == 0)
    {
        return false;
    }
    
    // 转换为大写字母，双引号之间的不能转换
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
    
    // 去除行首尾空格和\t
    sSrc.erase(0, sSrc.find_first_not_of(" \t\r"));
    sSrc.erase(sSrc.find_last_not_of(" \t\r") + 1);
    sSrc.erase(0, sSrc.find_first_not_of("\t\r "));
    sSrc.erase(sSrc.find_last_not_of("\t\r ") + 1);
    if (sSrc.empty())
    {
        return false;
    }
        
    // 获取类型和优先级
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

            //进一步判断是否为ELSE IF
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
            //进一步判断是否为END IF
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
            // 没有找到关键字，可能是如下三种情况
            // 1.赋值，AA = 112233
            // 2.可执行语句 0084000008
            // 3.函数定义，MyFun:
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
    
    sScriptInfo.vVerValue = split(sSrc.substr(nLen + 1));    //将后面所有的数据，按照特定字符进行分割

    //如果是for或Hfor语句，需要特殊处理一下，重新解析一下判断语句
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
        //Load_Script语句，将文件名存起来
        vLoadScript.push_back(sScriptInfo.vVerValue.at(1));
        return true;
    }

    m_ScriptInfo.push_back(sScriptInfo);

    return true;
}


/*
* ********************************************************************
* 函数名称:  ReadScript
* 函数说明:  读取脚本文件。
* 写作日期:  2019/01/03
* ********************************************************************
*/
bool CParseScript::ReadScript(string sFileName)
{
    if (sFileName.empty())
    {
        return false;
    }

    //获取文件的编码类型
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

            //字符转换。Linux和MAC下需要转换为 Utf8
#ifndef _WIN32
            ANSItoUTF8(sTemp);
#endif
            ParseLine(sTemp, nLine++, nPri);

            memset(sSrc, 0, sizeof(sSrc));
        }
    } 
    else if (nEncoding == FILE_UNICODE)
    {
        //目前有问题，待实现
        return false;

        fseek(fptr, sizeof(wchar_t), 0);

        wchar_t sSrc[20000] = {0};
        while(fscanf(fptr, "%w[^\n]", sSrc) != EOF)
        {
            fgetc(fptr);

            string sTemp = "";

            //字符转换。Windows下需要转换为ANSI，Linux和MAC下需要转换为 Utf8
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

            //字符转换。Windows下需要转换为 ANSI
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
* 函数名称:  CheckScript
* 函数说明:  校验读取的脚本是否合法。
* 写作日期:  2019/01/03
* ********************************************************************
*/
bool CParseScript::CheckScript()
{
    if (m_ScriptInfo.empty())
    {
        return false;
    }

    //通过优先级校验脚本是否正确。
    //主要是if与endif是否匹配，for和next是否匹配，do和loop是否匹配，将函数部分单独提取到m_FunInfo
    list<int> pPri;
    for (VCT_SCRIPTINFO::iterator it = m_ScriptInfo.begin(); it != m_ScriptInfo.end(); )
    {
        //遇到如下几种类型，说明要进入某个流程，保存一下各自的优先级
        if (it->nScrKind == Kind_If ||
            it->nScrKind == Kind_DO ||
            it->nScrKind == Kind_For ||
            it->nScrKind == Kind_HFor)
        {
            pPri.push_back(it->nScrPri);
            it++;
            continue;
        }

        //遇到如下几种类型，且优先级与pPri最后一个元素相同，表示匹配
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

        //如果是函数定义，则重新保存到m_FunInfo
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

    //校验，如果所有流程均完全匹配，则pPri应该为空
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
* 函数名称:  RunScript
* 函数说明:  运行整个脚本。
* 写作日期:  2019/01/03
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
* 函数名称:  RunLine
* 函数说明:  执行单行脚本。
* 写作日期:  2019/01/03
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
* 函数名称:  Parse_Operator
* 函数说明:  解析表达式语句
* 写作日期:  2019/01/03
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
            //遇到第一个操作符时，获取左值
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

    //补齐成相同的长度
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

    //比较
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
* 函数名称:  Parse_Message
* 函数说明:  解析Message语句
* 写作日期:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_Message(vector<string> vScript)
{
    string sTemp = "";

    int nStart = 0;
    int nEnd = 0;

    //双引号内部的变量，不需要转换，当成字符串打印
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
* 函数名称:  Parse_PrintErr
* 函数说明:  解析PrintErr语句
* 写作日期:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_PrintErr(int nLine, vector<string> vScript)
{
    string sTemp = "";

    int nStart = 0;
    int nEnd = 0;

    //双引号内部的变量，不需要转换，当成字符串打印
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
* 函数名称:  Parse_Set
* 函数说明:  解析Set语句
* 写作日期:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_Set(vector<string> vScript)
{
    // 如果只有一个节点，说明脚本格式为 set AA，默认返回RESULT的值
    if (vScript.size() == 1)
    {
        SetVarValue(vScript.at(0), GetVarValue("RESULT"));
//        Comm.WriteRunLog("Set %s = %s", vScript.at(0).c_str(), GetVarValue("RESULT").c_str());
        printf("Set %s = %s", vScript.at(0).c_str(), GetVarValue("RESULT").c_str());
        return;
    }

    string sTemp = "";

    // 格式可能为：
    //      AA = 112233         固定字符串
    //      AA = "112233"       固定字符串，需要转换成31 31 32 32 33 33
    //      BB = $AA            变量赋值
    //      BB = (1122)         变量赋值，取长度，结果为02 1122
    //      BB = $AA 112233     固定字符串 和 变量
    //      BB = add(01,02)     带参数的函数调用
    //      BB = rand           不带参数的函数调用
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
            //下一个节点表示变量名，获取变量值
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
            //走到这一步，说明是需要()内部数据的长度
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
            //走到这一步，说明是需要<>内部数据的长度
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
            //走到这一步，说明是需要<>内部数据的长度
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
            //到这一步，该字符串可能是函数名，也可能是常量字符
            //依据set函数的规律，如果是函数名，则后面必然带有()
            //否则就是常量字符串
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

                //解析参数。如果是函数调用，兼容snooper，单行只支持一个函数表达式
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
                        //遇到双引号，截取之间的数据
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

                //执行系统函数
                sTemp += Parse_CallSysFun(sFunName);
            } 
            else
            {
                //纯字符串，直接连接上就行了
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
* 函数名称:  Parse_IF
* 函数说明:  解析if模块，直到同级的end if语句出现。
* 写作日期:  2019/01/03
* ********************************************************************
*/
bool CParseScript::Parse_IF(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd)
{
    //是否正常执行到结束
    bool bEnd = true;

    //备份一下if语句的优先级
    int nPri = it->nScrPri;

    //if或者else if语句是否被执行过
    //如果执行过，则后续所有的if和else if均不必执行
    bool isInProcess = false;

    while (true)
    {
        //如果遇到end if，需要判断优先级是否和if的一致。该操作是为了if内层的嵌套
        if (it->nScrKind == Kind_EndIf)
        {
            if (it->nScrPri == nPri)
            {
                // 只有优先级相同，才表示if模块结束。
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

        //if和else if模块，后续的验证相同
        if (it->nScrKind == Kind_If || it->nScrKind == Kind_ElseIf)
        {
            //判断if的表达式是否为真
            bool bIfResult = Parse_Operator(it->vVerValue);

            //不执行if模块所有的指令
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
                    //如果if模块在for循环内嵌套，当遇到exit for，退出
                    if (it->nScrKind == Kind_ExitFor ||
                        it->nScrKind == Kind_ExitHFor)
                    {
                        bEnd = false;
                        break;
                    }
                    RunLine(it, itEnd);
                }
            }

            //如果if表达式为真，且没有执行过if或else if模块，则将isInProcess置为true。以此只保证执行一次if和else if
            if (bIfResult && !isInProcess)
            {
                isInProcess = true;
            }
        }

        //else模块
        if (it->nScrKind == Kind_Else)
        {
            while ((it++) != itEnd)
            {
                //走到这里，后续只能跟end if进行匹配
                if (it->nScrKind == Kind_EndIf)
                {
                    break;
                }
                if (it->nScrKind == Kind_End ||
                    it->nScrKind == Kind_Return)
                {
                    return bEnd;
                }

                //如果if和else if均没有执行，则执行else下面的指令
                if (!isInProcess)
                {
                    //如果if模块在for循环内嵌套，当遇到exit for，退出
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
* 函数名称:  Parse_For
* 函数说明:  解析for或hfor模块，直到循环结束。
* 写作日期:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_For(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd)
{
    //备份一下for语句的优先级
    int nPri = it->nScrPri;

    //for语句的起始位置和终止位置
    VCT_SCRIPTINFO::iterator it_ForBegin    = it;
    VCT_SCRIPTINFO::iterator it_ForEnd      = it;

    //for模块下的语句是否应该执行。如果遇到exit for，则后续语句都不被执行
    bool isInProcess = true;

    //*********************************解析条件语句*********************************//
    string sName = "";  //游标名称
    int nFlag = 0;      //游标大小
    int nBegin  = 0;    //起始值
    int nEnd    = 0;    //结束值
    int nStep   = 1;    //循环的步长，默认是1
    int nFormats = 10;  //进制

    if (it->nScrKind == Kind_DO)
    {
        //do  loop循环，格式为do 20000
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
        //for和Hfor循环
        if (it->vVerValue.size() < 5)
        {
            cout << "For 语句错误，请参考格式：for 表达式1 = 表达式2 to 表达式3 step 表达式4" << endl;
            return;
        }

        sName = it->vVerValue.at(0);
        
        if (it->nScrKind == Kind_For)
        {
            //For，参数为10进制
            nFormats = 10;
        }
        else
        {
            //HFor，参数为16进制
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
        
        //更新到全局变量
        SetVarValue(sName, it->vVerValue.at(2));
    }    

    //*********************************执行循环语句*********************************//
    while (true)
    {
        it = it_ForBegin;

        while ((it++) != itEnd)
        {
            if (it->nScrKind == Kind_ExitFor ||
                it->nScrKind == Kind_ExitHFor)
            {
                //不退出循环，继续查找next
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
                    // 只有优先级相同，才表示for模块结束。
                    it_ForEnd = it;
                    break;
                }
            }
            
            //如果中途遇到exit for，则后续语句不必再执行
            if (isInProcess)
            {
                if (!RunLine(it, itEnd))
                {
                    isInProcess = false;
                }
            }
        }
        
        //判断是否应该退出for循环，系统变量中只存储16进制的数
        nFlag = strtol(GetVarValue(sName).c_str(), NULL, 16);
        nFlag += nStep;

        //可能snooper写的有问题，格式为：for a = 0 to 5，区间为[0, 5]。格式为：do 5，区间为[0, 5)。为了兼容snooper，所以得特殊处理一下
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

    // 将it指向next的下一个节点
    it = it_ForEnd++;
}


/*
* ********************************************************************
* 函数名称:  Parse_Call
* 函数说明:  解析自定义的函数。
* 写作日期:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_Call(vector<string> vScript)
{
    string sFunName = "";
    vParameter.clear();

    //先解析函数名和参数
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

    //查找缓存的函数列表，执行函数
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
* 函数名称:  Parse_Run
* 函数说明:  需要执行的脚本。
* 写作日期:  2019/01/03
* ********************************************************************
*/
void CParseScript::Parse_Run(vector<string> vScript)
{
    if (vScript.at(0) == "CLEAR")
    {
    }
    else if (vScript.at(0) == "PAUSE")
    {
        printf("Pauth, 请按任意键继续...");
        getchar();
    }
    else if (vScript.at(0) == "TIMER_BEGIN")
    {
//        Comm.WriteRunLog("开始计时...");
        printf("开始计时...");
        m_bTime = true;
        m_Time = 0;
    }
    else if (vScript.at(0) == "TIMER_END")
    {
        int nFlag = strtol(GetVarValue("PERFORMANCETIMES").c_str(), NULL, 16);
        m_bTime = false;
//        Comm.WriteRunLog("结束计时。运行次数%d，平均耗时 %.3f ms", nFlag, (double)(m_Time / nFlag));
        printf("结束计时。运行次数%d，平均耗时 %.3f ms", nFlag, (double)(m_Time / nFlag));
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
                //走到这一步，说明是需要()内部数据的长度
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
        
        //存储结果
        SetVarValue("SW", Byte2Hex(pbRecv + dwRecvLen - 2, 2));
        SetVarValue("RESULT", Byte2Hex(pbRecv, dwRecvLen - 2));

        //打印结果
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
* 函数名称:  Reader_Enum
* 函数说明:  枚举读卡器。
* 写作日期:  2019/01/03
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
* 函数名称:  Reader_CosOpen
* 函数说明:  打开指定的读卡器，并连接卡片。
* 写作日期:  2019/01/03
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
* 函数名称:  Reader_CosClose
* 函数说明:  关闭连接。
* 写作日期:  2019/01/03
* ********************************************************************
*/
LONG CParseScript::Reader_CosClose(DWORD scd)
{
//    return m_Cos.FT_CosClose(&m_Card, scd);
    return SCardDisconnect(m_card, SCARD_UNPOWER_CARD);
}


/*
* ********************************************************************
* 函数名称:  Reader_SCardReleaseContext
* 函数说明:  释放上下文。
* 写作日期:  2019/01/03
* ********************************************************************
*/
LONG CParseScript::Reader_SCardReleaseContext()
{
//    return m_Cos.FT_SCardReleaseContext();
    return SCardReleaseContext(gContxtHandle);
}


/*
* ********************************************************************
* 函数名称:  Reader_Transmit
* 函数说明:  给指定的读卡器发送COS命令。
* 写作日期:  2019/01/03
* ********************************************************************
*/
LONG CParseScript::Reader_Transmit(BYTE *pbApdu, int apdulen, BYTE *recv, DWORD * retlen)
{
    //    return m_Cos.FT_Transmit(&m_Card, pbApdu, apdulen, recv, retlen);
    SCARD_IO_REQUEST pioSendPci;
    return SCardTransmit(gCardHandle, &pioSendPci, (unsigned char*)pbApdu, apdulen, NULL, (LPBYTE)recv, (LPDWORD)retlen);
}
