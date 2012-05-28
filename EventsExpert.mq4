#include <Events.mq4>

//---- let's define nShowCmd values
#define SW_HIDE 0
#define SW_SHOWNORMAL 1
#define SW_NORMAL 1
#define SW_SHOWMINIMIZED 2
#define SW_SHOWMAXIMIZED 3
#define SW_MAXIMIZE 3
#define SW_SHOWNOACTIVATE 4
#define SW_SHOW 5
#define SW_MINIMIZE 6
#define SW_SHOWMINNOACTIVE 7
#define SW_SHOWNA 8
#define SW_RESTORE 9
#define SW_SHOWDEFAULT 10
#define SW_FORCEMINIMIZE 11
#define SW_MAX 11

//---- we need to define import of SHELL32 DLL
#import "shell32.dll"
//---- defining ShellExecute
/* Normally we should define ShellExecute like this:
int ShellExecuteA(int hWnd,string lpVerb,string lpFile,string lpParameters,string lpDirectory,int nCmdShow);

But, we need to keep lpVerb,lpParameters and lpDirectory as NULL pointer to this function*/
//---- So we need to define it as (look: "string" parameters defined as "int" to keep them NULL):
int ShellExecuteA(int hWnd, int lpVerb, string lpFile, string lpParameters, int lpDirectory, int nCmdShow);
//---- we need to close import definition here
#import

extern int MagicNumber = 0;
extern bool   AlertPopup    = true;
extern bool   AlertExe      = false;
extern string Cmdline       = "notepad.exe";
extern bool   AlertMail     = false;
extern string MailBodyLine1 = "";
extern string MailBodyLine2 = "";
extern string MailBodyLine3 = "";
extern string MailBodyLine4 = "";
extern string MailBodyLine5 = "";
extern string MailBodyLine6 = "";

 
int start()
{
    CheckEvents( MagicNumber );
 
    if ( eventBuyClosed_SL > 0 )
        notify( ": Buy position was closed by StopLoss!" );
 
    if ( eventBuyClosed_TP > 0 )
        notify( ": Buy position was closed by TakeProfit!" );
 
    if ( eventBuyLimitOpened > 0 || eventBuyStopOpened > 0 || 
          eventSellLimitOpened > 0 || eventSellStopOpened > 0 )
        notify( ": pending order triggered!" );

return(0);
}

void notify(string comment) {         
         string alertString = "TradeAlert: " + comment;
         
         if (AlertPopup) {
            Alert(alertString);
         }
         
         if (AlertExe) {
            shellExecute(Cmdline, alertString);
         }
         
         if (AlertMail) {
            string mailBody = "text:" + alertString + "\n" + MailBodyLine1 + "\n" + MailBodyLine2 + "\n" + MailBodyLine3  + "\n" + MailBodyLine4 + "\n" + MailBodyLine5 + "\n" + MailBodyLine6;
            SendMail(alertString, mailBody);
         }
}

int shellExecute(string command, string args) {
   ShellExecuteA(0, "open", command, args, 0, SW_SHOWNA);
}
