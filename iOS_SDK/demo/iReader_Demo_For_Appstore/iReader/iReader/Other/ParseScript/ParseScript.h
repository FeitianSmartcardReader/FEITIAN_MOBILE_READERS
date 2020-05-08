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
    Kind_FunDef, Kind_FunCall, Kind_Return, //�Զ��庯��
    Kind_Run,
    Kind_End
} KIND;

struct SysVer
{
    string sVerName;
    string sVerValue;
};
typedef map<string, string> MAP_SYSVER; //ϵͳ������map��


struct ScriptInfo
{
    int nScrPri;    //������ȼ�
    int nScrKind;   //�������
    int nScrLine;   //�����������
    vector<string> vVerValue;
};
typedef vector<ScriptInfo> VCT_SCRIPTINFO;  //����б�


struct FunInfo
{
    string sFunName;
    VCT_SCRIPTINFO vScriptInfo;
};
typedef vector<FunInfo> VCT_FUNINFO;    //�����б�


class CParseScript
{
public:
    CParseScript();
    ~CParseScript();

    //��ȡ�ű��ļ�
    bool ReadScript(string sFileName);
    //У���ȡ�Ľű��Ƿ�Ϸ�
    bool CheckScript();
    //���������ű�
    bool RunScript();

    //�ָ�ÿ�еĽű���sSrc��ʾԴ�ַ�����sSeperator�����������ָ���
    vector<string> split(const string &sSrc, const string &sSeperator = ",\"$()<>{}!=:");

    //����ϵͳ����
    void SetVarValue(string sVarName, string sVarValue);
    //��ȡϵͳ����
    string GetVarValue(string sVarName);

    //�ж��Ƿ�Ϊϵͳ������
    bool JudgeFun(string sFunName);
    string Parse_CallSysFun(string sFunName);

    //��ȡ·���������ļ���
    void GetFiles(const char *sPath, vector<string>& files);

    //�������нű�
    bool ParseLine(string sSrc, int nLine, int &nPri);
    //���е��нű�
    bool RunLine(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd);

    //�������ؼ���
    bool Parse_Operator(vector<string> vScript);
    void Parse_Message(vector<string> vScript);
    void Parse_PrintErr(int nLine, vector<string> vScript);
    void Parse_Set(vector<string> vScript);
    bool Parse_IF(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd);
    void Parse_For(VCT_SCRIPTINFO::iterator &it, VCT_SCRIPTINFO::iterator itEnd);
    void Parse_Call(vector<string> vScript);
    void Parse_Run(vector<string> vScript);

    //���������
    //ö�ٶ�����
    int Reader_Enum(char reader_list[][256]);
    //��ָ���Ķ������������ӿ�Ƭ
    LONG Reader_CosOpen(DWORD dwpreferredprotocal, string reader_name);
    //�ر�����
    LONG Reader_CosClose(DWORD scd);
    LONG Reader_SCardReleaseContext();
    //��ָ���Ķ���������COS����
    LONG Reader_Transmit(BYTE *pbApdu, int apdulen, BYTE *recv, DWORD * retlen);

public:
    vector<string> vLoadScript;     //��Ҫ���ص����ļ��б�
    MAP_SYSVER m_SysVer;            //ϵͳ����
    VCT_SCRIPTINFO m_ScriptInfo;    //����б�
    VCT_FUNINFO m_FunInfo;          //�����б�
    vector<string> vParameter;      //�Զ��庯���Ĳ�����pop��һ��Ҫɾ����
    
    map<string, FUN_PTR> m_FunPtr;  //�������ͺ���ָ��
//    CSCos m_Cos;                    //SCos��ʵ��
    string m_ReadName;              //���ڲ��ԵĶ���������
//    IC_CARD m_Card;                 //
    SCARDHANDLE m_card;
    DWORD m_Time;                   //Timer_Begin֮�󣬿�ʼͳ�Ƶ��ܺ�ʱ
    bool  m_bTime;                  //�Ƿ���Ҫͳ��ʱ��
};

#endif
