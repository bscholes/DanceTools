// defines for managing trade orders
#define RETRYCOUNT    10
#define RETRYDELAY    500

#define LONG          1
#define SHORT         -1
#define ALL           0

#include <stdlib.mqh>

int Slippage = 2;
bool WriteScreenshots = true;

int init() {

   if(Digits == 3 || Digits == 5 )
      Slippage *= 10;
}

int start()  {
   
   ExitHalf( ALL );
   
   return(0);
}
  

void ExitHalf(int direction) {
   
   int lastTicket = LastOpenTicket();
   
   Comment(StringConcatenate("Exiting half of position", lastTicket));

   OrderSelect(lastTicket, SELECT_BY_TICKET, MODE_TRADES);
   double orderLots   = OrderLots() / 2.0;
   double orderProfit = OrderProfit() / 2.0;
      
   if(OrderSymbol() == Symbol()) {
      if (OrderType() == OP_BUY && ( direction == LONG || direction == ALL) ) { 
        Exit(OrderTicket(), LONG, orderLots, CLR_NONE); 
      }

      if (OrderType() == OP_SELL && ( direction == SHORT || direction == ALL) ) { 
        Exit(OrderTicket(), SHORT, orderLots, CLR_NONE); 
      }

      Comment(StringConcatenate(orderLots, " of order", lastTicket, " closed with profit ", orderProfit));
   }
}
  
bool Exit(int ticket, int dir, double volume, color clr, int t = 0)  {
    int i, j, cmd;
    double prc, sl, tp, lots;
    string cmt;

    bool closed;

    Print("Exit("+dir+","+DoubleToStr(volume,3)+","+t+")");

    for (i=0; i<RETRYCOUNT; i++) {
        for (j=0; (j<50) && IsTradeContextBusy(); j++)
            Sleep(100);
        RefreshRates();

        if (dir == LONG) {
            prc = Bid;
        }
        if (dir == SHORT) {
            prc = Ask;
       }
        Print("Exit: prc="+DoubleToStr(prc,Digits));

        closed = OrderClose(ticket,volume,prc,Slippage,clr);
        if (closed) {
            Print("Trade closed");
            Screenshot("Exit");

            return (true);
        }

        Print("Exit: error \'"+ErrorDescription(GetLastError())+"\' when exiting with "+DoubleToStr(volume,3)+" @"+DoubleToStr(prc,Digits));
        Sleep(RETRYDELAY);
    }

    Print("Exit: can\'t enter after "+RETRYCOUNT+" retries");
    return (false);
}

// return ticket of last opened order on this charts currency
int LastOpenTicket() {
    int      pos;
    datetime lastTime  = 0;
    int      lastTicket = -1; // None open.
    for(pos = OrdersTotal()-1; pos >= 0 ; pos--) {
      if ( OrderSelect(pos, SELECT_BY_POS) 
        && OrderSymbol() == Symbol() 
        && OrderOpenTime() > lastTime) {
        lastTime   = OrderOpenTime();
        lastTicket = OrderTicket();
      }
    }

    return(lastTicket);
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


