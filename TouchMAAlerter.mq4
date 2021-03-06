//+------------------------------------------------------------------+
//|                                                      TouchMA.mq4 |
//|                                                       Hans Baier |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Hans Baier"
#property link      ""

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

//--- input parameters

extern double CatchPips     = 3;
extern bool   AlertPopup    = true;
extern bool   AlertExe      = false;
extern string Cmdline       = "notepad.exe";

extern bool   Trade5EMA     = false;
extern bool   Trade10EMA    = true;
extern bool   Trade21EMA    = true;
extern bool   Trade35SMA    = true;
extern bool   Trade50EMA    = true;
extern bool   Trade89EMA    = true;
extern bool   Trade144EMA   = true;
extern bool   Trade200SMA   = true;

extern bool   AlertMail     = false;
extern string MailBodyLine1 = "";
extern string MailBodyLine2 = "";
extern string MailBodyLine3 = "";
extern string MailBodyLine4 = "";
extern string MailBodyLine5 = "";
extern string MailBodyLine6 = "";

extern bool   debug         = false;

int Bars5EMA   = 0;
int Bars10EMA  = 0;
int Bars21EMA  = 0;
int Bars35SMA  = 0;
int Bars50EMA  = 0;
int Bars89EMA  = 0;
int Bars144EMA  = 0;
int Bars200SMA  = 0;

double multiplier = 1.0;
int digits;

int init() {
   digits = MarketInfo(Symbol(), MODE_DIGITS);
   if (digits == 5) multiplier = 10.0;
   Print("TouchEAAlerter init... happy trading...");
   

   return(0);
}

int deinit() {
   return(0);
}

int start() {  
   double price  = 0.0;
   double spread = Ask - Bid;
       
      string comment;

      if (Trade5EMA && Bars > Bars5EMA) {
         comment = "Touch5";
         double ema5  = iMA(NULL, 0,  5, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema5, digits);
         Bars5EMA = checkTouch(price, comment);
      } 

      if (Trade10EMA && Bars > Bars10EMA) {
         comment = "Touch10";
         double ema10  = iMA(NULL, 0,  10, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema10, digits);
         Bars10EMA = checkTouch(price, comment);
      } 

      if (Trade21EMA && Bars > Bars21EMA) {
         comment = "Touch21";
         double ema21  = iMA(NULL, 0,  21, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema21, digits);
         Bars21EMA = checkTouch(price, comment);
      } 

      if (Trade35SMA && Bars > Bars35SMA) {
         comment = "Touch35";
         double sma35  = iMA(NULL, 0,  35, 0, MODE_SMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(sma35, digits);
         Bars35SMA = checkTouch(price, comment);
      } 

      if (Trade50EMA && Bars > Bars50EMA) {
         comment = "Touch50";
         double ema50  = iMA(NULL, 0,  50, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema50, digits);
         Bars50EMA = checkTouch(price, comment);
      } 

      if (Trade89EMA && Bars > Bars89EMA) {
         comment = "Touch89";
         double ema89  = iMA(NULL, 0,  89, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema89, digits);
         Bars89EMA = checkTouch(price, comment);
      } 

      if (Trade144EMA && Bars > Bars144EMA) {
         comment = "Touch144";
         double ema144 = iMA(NULL, 0, 144, 0, MODE_EMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(ema144, digits);
         Bars144EMA = checkTouch(price, comment);
      } 

      if (Trade200SMA && Bars > Bars200SMA) {
         comment = "Touch200";
         double sma200 = iMA(NULL, 0, 200, 0, MODE_SMA, PRICE_CLOSE, 0);
         price = NormalizeDouble(sma200, digits);
         Bars200SMA = checkTouch(price, comment);
      } 
      
      if(debug) {
         //Print("Digits: " + digits + " multiplier: " + multiplier + " Point: " + Point);
         Print("_________________________");
         Print("Spread: " + spread);
         Print("Bid Price: " + Bid);
         Print("Price MA: " + price);
         Print("comment" + comment);
      }
         
   return(0);
}

int checkTouch(double price, string comment) {
      if (debug) {
         Print("Bars" + Bars);
         Print(comment + " " + Bars10EMA);
      }
      double delta    = Bid - price;
      double distance = MathAbs(delta);
      if(distance < CatchPips * Point * multiplier) {
         distance /= Point * multiplier;
         
         string alertString = "PriceAlert " + comment + " on " + Symbol() + " " + Period() + " price " + price + " distance " + delta + " (" + Bid + ")";
         
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
         
         return(Bars);
      } 
      
      return(0);
}

int shellExecute(string command, string args) {
   ShellExecuteA(0, "open", command, args, 0, SW_SHOWNA);
}
