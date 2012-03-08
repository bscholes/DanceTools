//+------------------------------------------------------------------+
//|                                                 _CloseOrders.mq4 |
//|                                         Copyright © 2007, sx ted |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, sx ted"
//#property show_inputs

//+------------------------------------------------------------------+
//| EX4 imports                                                      |
//+------------------------------------------------------------------+
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| input parameters:                                                |
//+-----------0---+----1----+----2----+----3]------------------------+
extern string _ = "Select one of the following:";
extern bool   CloseOpenOrdersAndCancelPending = true;
extern bool   CloseOpenOrders = false;
extern bool   DeleteAllPendingOrders = false;
extern int    DeletePendingWithMagicNumber = 0;
extern string DeletePendingMatchingComment = "";
extern int    CloseOrdersMatchingMagicNumber = 0;
extern string CloseOrdersMatchingComment = "";
extern bool   CloseOrdersWithPlusProfit = false;
extern bool   CloseOrdersWithMinusProfit = false;
extern bool   CloseOrdersOpenedBeforeToday = false;

//+------------------------------------------------------------------+
//| global variables to program:                                     |
//+------------------------------------------------------------------+
double Price[2];
int    giSlippage;

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void start() {
  int iOrders=OrdersTotal()-1, i;
  
  if(CloseOpenOrdersAndCancelPending) {
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) {
        if((OrderType()<=OP_SELL) && GetMarketInfo()) {
          if(!OrderClose(OrderTicket(),OrderLots(),Price[1-OrderType()],giSlippage)) Print(OrderError());
        }
        else if(OrderType()>OP_SELL) {
          if(!OrderDelete(OrderTicket())) Print(OrderError());
        }
      }
    }
  }
  else if(CloseOpenOrders) {
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderType()<=OP_SELL) && GetMarketInfo() && !OrderClose(OrderTicket(),OrderLots(),Price[1-OrderType()],giSlippage)) Print(OrderError());
    }
  }
  if(DeleteAllPendingOrders) {
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderType()>OP_SELL) && !OrderDelete(OrderTicket())) Print(OrderError());
    }
  }
  else if(DeletePendingWithMagicNumber > 0) {
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderMagicNumber() == DeletePendingWithMagicNumber)) {
        if(OrderType()>OP_SELL) {
          if(!OrderDelete(OrderTicket())) Print(OrderError());
        }
      }
    }
  }
  else if(DeletePendingMatchingComment != "") {
    DeletePendingMatchingComment=StringChangeToUpperCase(DeletePendingMatchingComment);
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (StringChangeToUpperCase(OrderComment()) == DeletePendingMatchingComment)) {
        if(OrderType()>OP_SELL) {
          if(!OrderDelete(OrderTicket())) Print(OrderError());
        }
      }
    }
  }
  else if(CloseOrdersMatchingMagicNumber > 0) {
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderMagicNumber() == CloseOrdersMatchingMagicNumber)) {
        if((OrderType()<=OP_SELL) && GetMarketInfo()) {
          if(!OrderClose(OrderTicket(),OrderLots(),Price[1-OrderType()],giSlippage)) Print(OrderError());
        }
      }
    }
  }
  else if(CloseOrdersMatchingComment != "") {
    CloseOrdersMatchingComment=StringChangeToUpperCase(CloseOrdersMatchingComment);
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (StringChangeToUpperCase(OrderComment()) == CloseOrdersMatchingComment)) {
        if((OrderType()<=OP_SELL) && GetMarketInfo()) {
          if(!OrderClose(OrderTicket(),OrderLots(),Price[1-OrderType()],giSlippage)) Print(OrderError());
        }
      }
    }
  }
  else if(CloseOrdersWithPlusProfit) {
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderProfit() >= 0)) {
        if((OrderType()<=OP_SELL) && GetMarketInfo()) {
          if(!OrderClose(OrderTicket(),OrderLots(),Price[1-OrderType()],giSlippage)) Print(OrderError());
        }
      }
    }
  }
  else if(CloseOrdersWithMinusProfit) {
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderProfit() <= 0)) {
        if((OrderType()<=OP_SELL) && GetMarketInfo()) {
          if(!OrderClose(OrderTicket(),OrderLots(),Price[1-OrderType()],giSlippage)) Print(OrderError());
        }
      }
    }
  }
  else if(CloseOrdersOpenedBeforeToday) {
    datetime tTodayStart=TimeCurrent()-TimeHour(TimeCurrent())*60*60-TimeMinute(TimeCurrent())*60;
    for(i=iOrders; i>=0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && (OrderOpenTime() < tTodayStart)) {
        if((OrderType()<=OP_SELL) && GetMarketInfo()) {
          if(!OrderClose(OrderTicket(),OrderLots(),Price[1-OrderType()],giSlippage)) Print(OrderError());
        }
        else if(OrderType()>OP_SELL) {
          if(!OrderDelete(OrderTicket())) Print(OrderError());
        }
      }
    }
  }
}

//+------------------------------------------------------------------+
//| Function..: OrderError                                           |
//+------------------------------------------------------------------+
string OrderError() {
  int iError=GetLastError();
  return(StringConcatenate("Order:",OrderTicket()," GetLastError()=",iError," ",ErrorDescription(iError)));
}

//+------------------------------------------------------------------+
//| Function..: GetMarketInfo                                        |
//| Returns...: bool Success.                                        |
//+------------------------------------------------------------------+
bool GetMarketInfo() {
  RefreshRates();
  Price[0]=MarketInfo(OrderSymbol(),MODE_ASK);
  Price[1]=MarketInfo(OrderSymbol(),MODE_BID);
  double dPoint=MarketInfo(OrderSymbol(),MODE_POINT);
  if(dPoint==0) return(false);
  giSlippage=(Price[0]-Price[1])/dPoint;
  return(Price[0]>0.0 && Price[1]>0.0);
}

//+------------------------------------------------------------------+
//| Function..: StringChangeToUpperCase                              |
//| Example...: StringChangeToUpperCase("oNe mAn"); // ONE MAN       |
//+------------------------------------------------------------------+
string StringChangeToUpperCase(string sText) {
  int iLen=StringLen(sText), i, iChar;

  for(i=0; i < iLen; i++) {
    iChar=StringGetChar(sText, i);
    if(iChar >= 97 && iChar <= 122) sText=StringSetChar(sText, i, iChar-32);
  }
  return(sText);
}
//+------------------------------------------------------------------+