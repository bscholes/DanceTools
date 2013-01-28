//+------------------------------------------------------------------+
//|                                   luktom visual order editor.mq4 |
//|                                   luktom :: £ukasz Tomaszkiewicz |
//|                                               http://luktom.biz/ |
//+------------------------------------------------------------------+
#property copyright "luktom :: £ukasz Tomaszkiewicz"
#property link      "http://luktom.biz/"

#include <stderror.mqh>
#include <stdlib.mqh>

extern bool  use_timer=false;

extern int    default_sl_level=180;
extern int    default_tp_level=150;

extern color  sl_color=Orange;
extern int    sl_style=STYLE_DASH;
extern color  tp_color=DarkGray;
extern int    tp_style=STYLE_DASH;
extern color  be_color=Brown;
extern int    be_style=STYLE_DASH;
extern int    be_offset=0;
extern color  cl_color=Purple;
extern int    cl_style=STYLE_DASH;

extern bool   use_cp=false;
extern color  cp_color=Pink;
extern int    cp_style=STYLE_DASH;
extern int    cp_level=0;
extern int    cp_closedlevel=200;
extern double cp_lots=0;

extern color ol_sell_color=Red;
extern int   ol_sell_style=STYLE_DASH;
extern color ol_buy_color=Blue;
extern int   ol_buy_style=STYLE_DASH;

extern bool  use_be=false;
extern int   default_be_level=150;

extern bool  use_cl=false;
extern int   default_cl_level=200;

extern bool  delete_on_deinit=true;

void init() {
 
 if(use_timer) {
  timer();
 }
 
}


void timer() {

   while(true) {
    Sleep(1000);
     
    if(IsStopped()) {
     return;
    }
    
    start();
   }
   
}

void deinit() {
 
 if(delete_on_deinit) {
  for(int i=0;i<ObjectsTotal();i++) {
   string name=ObjectName(i);
  
   if(StringSubstr(name,0,4)=="lvoe") {
    ObjectDelete(name);
   }
  }
 }
   
}

void start() {

   for(int i=0; i<OrdersTotal();i++) {
    if(OrderSelect(i,SELECT_BY_POS)) {
     if(OrderSymbol()==Symbol()) {
      int dgts=MarketInfo(OrderSymbol(),MODE_DIGITS);
      
      if(ObjectFind("lvoe_ol_" + OrderTicket())==-1) {
       
       if(OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP) { 
        ObjectCreate("lvoe_ol_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice());
        ObjectSet("lvoe_ol_" + OrderTicket(),OBJPROP_COLOR,ol_sell_color); 
        ObjectSet("lvoe_ol_" + OrderTicket(),OBJPROP_STYLE,ol_sell_style); 
       }
       
       if(OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP) {
        ObjectCreate("lvoe_ol_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice());
        ObjectSet("lvoe_ol_" + OrderTicket(),OBJPROP_COLOR,ol_buy_color); 
        ObjectSet("lvoe_ol_" + OrderTicket(),OBJPROP_STYLE,ol_buy_style); 
       }
       
      } else {
       
       if(OrderType()==OP_SELL || OrderType()==OP_BUY) {
        ObjectDelete("lvoe_ol_" + OrderTicket());
       }
       
       align("lvoe_ol_" + OrderTicket());
       
       if(NormalizeDouble(OrderOpenPrice(),dgts)!=NormalizeDouble(ObjectGet("lvoe_ol_" + OrderTicket(),OBJPROP_PRICE1),dgts)) {
        if(!OrderModify(OrderTicket(),ObjectGet("lvoe_ol_" + OrderTicket(),OBJPROP_PRICE1),OrderStopLoss(),OrderTakeProfit(),OrderExpiration(),CLR_NONE)) {
         //Alert(ErrorDescription(GetLastError()));
        }
        continue;
       }
       
      }
      
      if(OrderStopLoss()>0 || default_sl_level>0) {
       if(ObjectFind("lvoe_sl_" + OrderTicket())==-1) {
       
        if(OrderStopLoss()==0) {
         ObjectCreate("lvoe_sl_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice()-orderDir(OrderType())*default_sl_level*Point);
        } else {
         ObjectCreate("lvoe_sl_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderStopLoss());
        }
        ObjectSet("lvoe_sl_" + OrderTicket(),OBJPROP_COLOR,sl_color); 
        ObjectSet("lvoe_sl_" + OrderTicket(),OBJPROP_STYLE,sl_style); 
        ObjectSetText("lvoe_sl_" + OrderTicket(),"#"+OrderTicket()+" stop loss",11);
       
       } else {
        align("lvoe_sl_" + OrderTicket());
        if(NormalizeDouble(OrderStopLoss(),dgts)!=NormalizeDouble(ObjectGet("lvoe_sl_" + OrderTicket(),OBJPROP_PRICE1),dgts)) {
         if(!OrderModify(OrderTicket(),OrderOpenPrice(),ObjectGet("lvoe_sl_" + OrderTicket(),OBJPROP_PRICE1),OrderTakeProfit(),OrderExpiration(),CLR_NONE)) {
          //Alert(ErrorDescription(GetLastError()));
         }
         continue;
        }
        
       }  
      } else {
       if(ObjectFind("lvoe_sl_" + OrderTicket())!=-1) {
        ObjectDelete("lvoe_sl_" + OrderTicket());
       }
      }
      
      if(OrderTakeProfit()>0 || default_tp_level) {
       if(ObjectFind("lvoe_tp_" + OrderTicket())==-1) {
       
        if(OrderTakeProfit()==0) {
         ObjectCreate("lvoe_tp_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice()+orderDir(OrderType())*default_tp_level*Point);
        } else {
         ObjectCreate("lvoe_tp_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderTakeProfit());
        }
        ObjectSet("lvoe_tp_" + OrderTicket(),OBJPROP_COLOR,tp_color); 
        ObjectSet("lvoe_tp_" + OrderTicket(),OBJPROP_STYLE,tp_style); 
       
       } else {
        align("lvoe_tp_" + OrderTicket());
        if(NormalizeDouble(OrderTakeProfit(),4)!=NormalizeDouble(ObjectGet("lvoe_tp_" + OrderTicket(),OBJPROP_PRICE1),4)) {
         if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ObjectGet("lvoe_tp_" + OrderTicket(),OBJPROP_PRICE1),OrderExpiration(),CLR_NONE)) {
          //Alert(ErrorDescription(GetLastError()));
         }
         continue;
        }
       
       }  
      } else {
       if(ObjectFind("lvoe_tp_" + OrderTicket())!=-1) {
        ObjectDelete("lvoe_tp_" + OrderTicket());
       }
      }
      
      if(use_cp && cp_level>0) {
       if(ObjectFind("lvoe_cp_" + OrderTicket())==-1) {
        if(OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP) {
         if(OrderStopLoss()<OrderOpenPrice()) {
          ObjectCreate("lvoe_cp_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice()+cp_level*MarketInfo(OrderSymbol(),MODE_POINT));
          ObjectSet("lvoe_cp_" + OrderTicket(),OBJPROP_COLOR,cp_color); 
          ObjectSet("lvoe_cp_" + OrderTicket(),OBJPROP_STYLE,cp_style); 
         }
        } else {
         if(OrderStopLoss()>OrderOpenPrice()) {
          ObjectCreate("lvoe_cp_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice()-cp_level*MarketInfo(OrderSymbol(),MODE_POINT));
          ObjectSet("lvoe_cp_" + OrderTicket(),OBJPROP_COLOR,cp_color); 
          ObjectSet("lvoe_cp_" + OrderTicket(),OBJPROP_STYLE,cp_style); 
         }
        } 
       } else {
        if(OrderType()==OP_BUY) {
         if(MarketInfo(OrderSymbol(),MODE_BID)>ObjectGet("lvoe_cp_" + OrderTicket(),OBJPROP_PRICE1)) {
          if(OrderClose(OrderTicket(),cp_lots,MarketInfo(OrderSymbol(),MODE_BID),0)) {
           ObjectSet("lvoe_cp_" + OrderTicket(),OBJPROP_PRICE1,MarketInfo(OrderSymbol(),MODE_BID)+cp_closedlevel*MarketInfo(OrderSymbol(),MODE_POINT));
          }
          continue;
         }
        }
        if(OrderType()==OP_SELL) {
         if(MarketInfo(OrderSymbol(),MODE_ASK)<ObjectGet("lvoe_cp_" + OrderTicket(),OBJPROP_PRICE1)) {
          if(OrderClose(OrderTicket(),cp_lots,MarketInfo(OrderSymbol(),MODE_ASK),0)) {
           ObjectSet("lvoe_cp_" + OrderTicket(),OBJPROP_PRICE1,MarketInfo(OrderSymbol(),MODE_ASK)-cp_closedlevel*MarketInfo(OrderSymbol(),MODE_POINT));  
          }
          continue;
         }
        }
       }
      }
      
      if(use_be) {
       if(ObjectFind("lvoe_be_" + OrderTicket())==-1) {
        if(OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP) {
         if(OrderStopLoss()<OrderOpenPrice()) {
          ObjectCreate("lvoe_be_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice()+default_be_level*MarketInfo(OrderSymbol(),MODE_POINT));
          ObjectSet("lvoe_be_" + OrderTicket(),OBJPROP_COLOR,be_color); 
          ObjectSet("lvoe_be_" + OrderTicket(),OBJPROP_STYLE,be_style); 
         }
        } else {
         if(OrderStopLoss()>OrderOpenPrice()) {
          ObjectCreate("lvoe_be_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice()-default_be_level*MarketInfo(OrderSymbol(),MODE_POINT));
          ObjectSet("lvoe_be_" + OrderTicket(),OBJPROP_COLOR,be_color); 
          ObjectSet("lvoe_be_" + OrderTicket(),OBJPROP_STYLE,be_style); 
         }
        } 
       } else {
        if(OrderType()==OP_BUY) {
         if(MarketInfo(OrderSymbol(),MODE_BID)>ObjectGet("lvoe_be_" + OrderTicket(),OBJPROP_PRICE1)) {
          ObjectSet("lvoe_sl_" + OrderTicket(),OBJPROP_PRICE1,OrderOpenPrice()+be_offset*MarketInfo(OrderSymbol(),MODE_POINT));
          /*
          if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),OrderExpiration(),CLR_NONE)) {
           //Alert(ErrorDescription(GetLastError()));
          }
          */
          continue;
         }
        }
        if(OrderType()==OP_SELL) {
         if(MarketInfo(OrderSymbol(),MODE_ASK)<ObjectGet("lvoe_be_" + OrderTicket(),OBJPROP_PRICE1)) {
          ObjectSet("lvoe_sl_" + OrderTicket(),OBJPROP_PRICE1,OrderOpenPrice()-be_offset*MarketInfo(OrderSymbol(),MODE_POINT));
          /*
          if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),OrderExpiration(),CLR_NONE)) {
           //Alert(ErrorDescription(GetLastError()));
          }
          */
          continue;
         }
        }
       }
      }
      
      if(use_cl) {
       if(ObjectFind("lvoe_cl_" + OrderTicket())==-1) {
        if(OrderType()!=OP_BUY && OrderType()!=OP_SELL) {
         if(OrderType()==OP_BUY || OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP) {
          ObjectCreate("lvoe_cl_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice()-default_cl_level*MarketInfo(OrderSymbol(),MODE_POINT));
          ObjectSet("lvoe_cl_" + OrderTicket(),OBJPROP_COLOR,cl_color); 
          ObjectSet("lvoe_cl_" + OrderTicket(),OBJPROP_STYLE,cl_style); 
         } else {
          ObjectCreate("lvoe_cl_" + OrderTicket(),OBJ_HLINE,0,Time[0],OrderOpenPrice()+default_cl_level*MarketInfo(OrderSymbol(),MODE_POINT));
          ObjectSet("lvoe_cl_" + OrderTicket(),OBJPROP_COLOR,cl_color); 
          ObjectSet("lvoe_cl_" + OrderTicket(),OBJPROP_STYLE,cl_style); 
         } 
        }
       } else {
        if(OrderType()==OP_BUYLIMIT || OrderType()==OP_BUYSTOP) {
         if(MarketInfo(OrderSymbol(),MODE_BID)<ObjectGet("lvoe_cl_" + OrderTicket(),OBJPROP_PRICE1)) {
          OrderDelete(OrderTicket());
         }
        }
        if(OrderType()==OP_SELLLIMIT || OrderType()==OP_SELLSTOP) {
         if(MarketInfo(OrderSymbol(),MODE_ASK)>ObjectGet("lvoe_cl_" + OrderTicket(),OBJPROP_PRICE1)) {
          OrderDelete(OrderTicket());
         }
        }
        if(OrderType()==OP_BUY || OrderType()==OP_SELL) {
         ObjectDelete("lvoe_cl_" + OrderTicket());
        }
       }
      }
      
     }
      
    }
   }
      
   for(i=0;i<OrdersHistoryTotal();i++) {
    if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) {
     if(ObjectFind("lvoe_ol_" + OrderTicket())!=-1) {
      ObjectDelete("lvoe_ol_" + OrderTicket());
     }
     if(ObjectFind("lvoe_tp_" + OrderTicket())!=-1) {
      ObjectDelete("lvoe_tp_" + OrderTicket());
     }
     if(ObjectFind("lvoe_sl_" + OrderTicket())!=-1) {
      ObjectDelete("lvoe_sl_" + OrderTicket());
     }
     if(ObjectFind("lvoe_be_" + OrderTicket())!=-1) {
      ObjectDelete("lvoe_be_" + OrderTicket());
     }
     if(ObjectFind("lvoe_cl_" + OrderTicket())!=-1) {
      ObjectDelete("lvoe_cl_" + OrderTicket());
     }
     if(ObjectFind("lvoe_cp_" + OrderTicket())!=-1) {
      ObjectDelete("lvoe_cp_" + OrderTicket());
     }
    }
   }

}

void align(string name) {
 ObjectSet(name,OBJPROP_PRICE1,NormalizeDouble(ObjectGet(name,OBJPROP_PRICE1),Digits));
}

int orderDir(int oType) {

 if(oType==OP_BUY  || oType==OP_BUYLIMIT  || oType==OP_BUYSTOP) return(1);
 if(oType==OP_SELL || oType==OP_SELLLIMIT || oType==OP_SELLSTOP) return(-1);

}