#ifndef __PARSESCRIPT___
#define __PARSESCRIPT___

#include "SysFunction.h"
//#include "SCos.h"

#ifdef _WIN32
#include <io.h>
#else
#include <dirent.h>
#include <sys/stat.h>
#include <sys/types.h>
#endif
//#include "commonality.h"
#include "winscard.h"
#include "wintypes.h"

typedef string (*FUN_PTR)(vector<string> &vParameter);


typedef enum {
    Kind_Start,
    Kind_Reset, 
    Kind_Notes, Kind_Message, Kind_PrintErr, Kind_LoadScript, Kind_Sleep, Kind_SetVar,
    Kind_If, Kind_ElseIf, Kind_Else, Kind_EndIf,
    Kind_For, Kind_Next, Kind_ExitFor, Kind_HFor, Kind_HNext, Kind_ExitHFor, Kind_DO, Kind_Loop,
    Kind_FunDef, Kind_FunCall, Kind_Return, //自定义函数
    Kind_Run,
    Kind_End
} KIND;

struct SysVer
{
    string sVerName;
    string sVerValue;
};
typedef map<string, string> MAP_SYSVER; //系统变量的map表


struct ScriptInfo
{
    int nScrPri;    //语句优先级
    int nScrKind;   //语句类型
    int nScrLine;   //语句所在行数
    vector<string> vVerValue;
};
typedef vector<ScriptInfo> VCT_SCRIPTINFO;  //语句列表


struct FunInfo
{
    string sFunName;
    VCT_SCRIPTINFO vScriptInfo;
};
typedef vector<FunInfo> VCT_FUNINFO;    //函数列表


class CParseScript
{
public:
    CParseScript();
    ~CParseScript();

    //读取脚本文件
    bool ReadScript(string sFileName);
    //校验读取的脚本是否合法
    bool CheckScript();
    //运行整个脚本
    bool RunScript();

    //分割每行的脚本，sSrc表示源字符串，sSeperator可以输入多个分隔符
    vector<string> split(const string &sSrc, const string &sSeperator = ",\"$()<>{}!=:");

    //设置系统变量
    void SetVarValue(string sVarName, string sVarValue);
    //获取系统变量
    string GetVarValue(string sVarName);

    //判断是否为系统函数名
    bool JudgeFun(string sFunName);
    string Parse_CallSysFun(string sFunName);

    //获取路径下所有文件名
    void GetFiles(const char *sPath, vector<string>& files);

    //解析单行脚本
    bool ParseLine(string sSrc, int nLine, int &nPri);
    //运行单行脚本
    bool RunLine(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd);

    //解析各关键字
    bool Parse_Operator(vector<string> vScript);
    void Parse_Message(vector<string> vScript);
    void Parse_PrintErr(int nLine, vector<string> vScript);
    void Parse_Set(vector<string> vScript);
    bool Parse_IF(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd);
    void Parse_For(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd);
    void Parse_Call(vector<string> vScript);
    void Parse_Run(vector<string> vScript);

    //读卡器相关
    //枚举读卡器
    int Reader_Enum(char reader_list[][256]);
    //打开指定的读卡器，并连接卡片
    LONG Reader_CosOpen(DWORD dwpreferredprotocal, string reader_name);
    //关闭连接
    LONG Reader_CosClose(DWORD scd);
    LONG Reader_SCardReleaseContext();
    //给指定的读卡器发送COS命令
    LONG Reader_Transmit(BYTE *pbApdu, int apdulen, BYTE *recv, DWORD * retlen);

public:
    vector<string> vLoadScript;     //需要加载的子文件列表
    MAP_SYSVER m_SysVer;            //系统变量
    VCT_SCRIPTINFO m_ScriptInfo;    //语句列表
    VCT_FUNINFO m_FunInfo;          //函数列表
    vector<string> vParameter;      //自定义函数的参数，pop后，一定要删除。
    
    map<string, FUN_PTR> m_FunPtr;  //函数名和函数指针
//    CSCos m_Cos;                    //SCos的实例
    string m_ReadName;              //正在测试的读卡器名称
//    IC_CARD m_Card;                 //
    SCARDHANDLE m_card;
    DWORD m_Time;                   //Timer_Begin之后，开始统计的总耗时
    bool  m_bTime;                  //是否需要统计时间
};

#endif
