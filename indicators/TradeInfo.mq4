//+------------------------------------------------------------------+
//|                                           TradingInfoDisplay.mq4 |
//|                                        Copyright © 2011, tigpips |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, tigpips"
#property link      ""

extern string font_type = "Arial";

string sellsymbol;
double sellprice;
double selllots;
double sellpips;

string buysymbol;
double buyprice;
double buylots;
double buypips;

#property indicator_chart_window

int init()
  {
   ObjectCreate("lbl_Sell_Symbol", OBJ_LABEL, 0, 0, 0);
   ObjectSet("lbl_Sell_Symbol", OBJPROP_XDISTANCE, 5);
   ObjectSet("lbl_Sell_Symbol", OBJPROP_YDISTANCE, 15);   
   ObjectSetText("lbl_Sell_Symbol","",8,font_type,Black);   
      
   ObjectCreate("lbl_Sell_Price", OBJ_LABEL, 0, 0, 0);
   ObjectSet("lbl_Sell_Price", OBJPROP_XDISTANCE, 102);
   ObjectSet("lbl_Sell_Price", OBJPROP_YDISTANCE, 15);
   ObjectSetText("lbl_Sell_Price","",8,font_type,Black);
      
   ObjectCreate("lbl_Sell_Pips1", OBJ_LABEL, 0, 0, 0);
   ObjectSet("lbl_Sell_Pips1", OBJPROP_XDISTANCE, 155);
   ObjectSet("lbl_Sell_Pips1", OBJPROP_YDISTANCE, 15);
   ObjectSetText("lbl_Sell_Pips1","",8,font_type,Black);
   
   ObjectCreate("lbl_Sell_Pips2", OBJ_LABEL, 0, 0, 0);  
   ObjectSet("lbl_Sell_Pips2", OBJPROP_XDISTANCE, 185);
   ObjectSet("lbl_Sell_Pips2", OBJPROP_YDISTANCE, 15);
   ObjectSetText("lbl_Sell_Pips2","",8,font_type,Black);    
     
   ObjectCreate("lbl_Buy_Symbol", OBJ_LABEL, 0, 0, 0);
   ObjectSet("lbl_Buy_Symbol", OBJPROP_XDISTANCE, 5);
   ObjectSet("lbl_Buy_Symbol", OBJPROP_YDISTANCE, 15);   
   ObjectSetText("lbl_Buy_Symbol","",8,font_type,Black);
      
   ObjectCreate("lbl_Buy_Price", OBJ_LABEL, 0, 0, 0);
   ObjectSet("lbl_Buy_Price", OBJPROP_XDISTANCE, 102);
   ObjectSet("lbl_Buy_Price", OBJPROP_YDISTANCE, 15);
   ObjectSetText("lbl_Buy_Price","",8,font_type,Black);
   
   ObjectCreate("lbl_Buy_Pips1", OBJ_LABEL, 0, 0, 0);
   ObjectSet("lbl_Buy_Pips1", OBJPROP_XDISTANCE, 155);
   ObjectSet("lbl_Buy_Pips1", OBJPROP_YDISTANCE, 15);
   ObjectSetText("lbl_Buy_Pips1","",8,font_type,Black);
   
   ObjectCreate("lbl_Buy_Pips2", OBJ_LABEL, 0, 0, 0);  
   ObjectSet("lbl_Buy_Pips2", OBJPROP_XDISTANCE, 185);
   ObjectSet("lbl_Buy_Pips2", OBJPROP_YDISTANCE, 15);
   ObjectSetText("lbl_Buy_Pips2","",8,font_type,Black);    
    
   return(0);
  }

int deinit()
  {
   ObjectsDeleteAll();

   return(0);
  }

int start()
  {
   int    counted_bars=IndicatorCounted();
   RefreshRates();
   sellsymbol = "";
   buysymbol = "";
   CheckTradeInfo();
   if(sellsymbol != "")
   {
      ObjectSetText("lbl_Sell_Symbol","Sell " + sellsymbol + " " + DoubleToStr(selllots,2) + "@",8,font_type,Black);  
      ObjectSetText("lbl_Sell_Price",DoubleToStr(sellprice,Digits),8,font_type,Black);      
      
      ObjectSetText("lbl_Sell_Pips1","Pips ",8,font_type,MediumBlue);       
      if(sellpips > 0)
      {
         ObjectSetText("lbl_Sell_Pips2","+"+DoubleToStr(sellpips/10,1),8,font_type,Green);             
      }
      else if(sellpips < 0)
      {
         ObjectSetText("lbl_Sell_Pips2",DoubleToStr(sellpips/10,1),8,font_type,Red);
      }
      else
      {
         ObjectSetText("lbl_Sell_Pips2",DoubleToStr(sellpips/10,1),8,font_type,MediumBlue);
      }      
   }
   else if(sellsymbol == "")
   {
      ObjectSetText("lbl_Sell_Symbol","",8,font_type,Black);
      ObjectSetText("lbl_Sell_Price","",8,font_type,Black);
      ObjectSetText("lbl_Sell_Pips1","",8,font_type,Black);
      ObjectSetText("lbl_Sell_Pips2","",8,font_type,Black);
   }
   
   if(buysymbol != "")
   {
      ObjectSetText("lbl_Buy_Symbol","Buy " + buysymbol + " " + DoubleToStr(buylots,2) + "@",8,font_type,Black);  
      ObjectSetText("lbl_Buy_Price",DoubleToStr(buyprice,Digits),8,font_type,Black);      
      
      ObjectSetText("lbl_Buy_Pips1","Pips ",8,font_type,MediumBlue);       
      if(buypips > 0)
      {
         ObjectSetText("lbl_Buy_Pips2","+"+DoubleToStr(buypips/10,1),8,font_type,Green);             
      }
      else if(buypips < 0)
      {
         ObjectSetText("lbl_Buy_Pips2",DoubleToStr(buypips/10,1),8,font_type,Red);
      }
      else
      {
         ObjectSetText("lbl_Buy_Pips2",DoubleToStr(buypips/10,1),8,font_type,MediumBlue);
      }      
   }
   else if(buysymbol == "")
   {
      ObjectSetText("lbl_Buy_Symbol","",8,font_type,Black);
      ObjectSetText("lbl_Buy_Price","",8,font_type,Black);
      ObjectSetText("lbl_Buy_Pips1","",8,font_type,Black);
      ObjectSetText("lbl_Buy_Pips2","",8,font_type,Black);
   }

   return(0);
  }
//+------------------------------------------------------------------+
void CheckTradeInfo()
{
   int lastTicket = LastOpenTicket();
   OrderSelect(lastTicket, SELECT_BY_TICKET, MODE_TRADES); 
   
   if (OrderCloseTime()==0 && lastTicket > 0) 
   { 
         if(OrderType()==OP_SELL)  
         {
            sellsymbol = OrderSymbol();
            sellprice = OrderOpenPrice();
            selllots = OrderLots();
            sellpips = ( OrderProfit() - OrderCommission() ) / OrderLots() / MarketInfo( OrderSymbol(), MODE_TICKVALUE );
         }
         else if(OrderType()==OP_BUY)
         {
            buysymbol = OrderSymbol();
            buyprice = OrderOpenPrice();
            buylots = OrderLots();
            buypips = ( OrderProfit() - OrderCommission() ) / OrderLots() / MarketInfo( OrderSymbol(), MODE_TICKVALUE );
         }     
   } 
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