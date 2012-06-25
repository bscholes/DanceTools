// defines for managing trade orders
#define RETRYCOUNT    10
#define RETRYDELAY    500

#define LONG          1
#define SHORT         -1
#define ALL           0

#property copyright "Go Markets, Programmed by OneStepRemoved.com"
#property link      "www.gomarketsaus.com"

#include <stdlib.mqh>

int Slippage = 2;
bool WriteScreenshots = false;

int init() {

   if(Digits == 3 || Digits == 5 )
      Slippage *= 10;
}

int start()  {
   
   DeletePendings( ALL );
   
   return(0);
}
  

void DeletePendings(int direction) {
   
   int total = 0;
   
   Comment("Deleting pending orders");

   for (int i = OrdersTotal()-1; i >= 0; i--) {           
      
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      
      if(OrderSymbol() == Symbol()) {
         total++;
         if ( (OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT ) && ( direction == LONG || direction == ALL) ) { DeletePending(OrderTicket(), Blue); }
         if ( (OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) && ( direction == SHORT || direction == ALL) ) { DeletePending(OrderTicket(), Red); }
      }
   }
   
   Comment(StringConcatenate(total, " pendings deleted."));
}
  
bool DeletePending(int ticket, color clr, int t = 0)  {
    int i, j, cmd;
    double prc, sl, tp, lots;
    string cmt;

    bool closed;

    Print(StringConcatenate("Deleting pending order ", ticket));

    for (i=0; i<RETRYCOUNT; i++) {
        for (j=0; (j<50) && IsTradeContextBusy(); j++)
            Sleep(100);
        RefreshRates();


        closed = OrderDelete(ticket);
        
        if (closed) {
            Print("Pending deleted");
            Screenshot("Exit");

            return (true);
        }

        Print("Delete Pending: error \'"+ErrorDescription(GetLastError()));
        Sleep(RETRYDELAY);
    }

    Print("Delete Pending: can\'t delete pending after "+RETRYCOUNT+" retries");
    return (false);
}

void Screenshot(string moment_name)
{
    if ( WriteScreenshots )
        WindowScreenShot(WindowExpertName()+"_"+Symbol()+"_M"+Period()+"_"+
                         Year()+"-"+two_digits(Month())+"-"+two_digits(Day())+"_"+
                         two_digits(Hour())+"-"+two_digits(Minute())+"-"+two_digits(Seconds())+"_"+
                         moment_name+".gif", 1024, 768);
}

string two_digits(int i)
{
    if (i < 10)
        return ("0"+i);
    else
        return (""+i);
}


