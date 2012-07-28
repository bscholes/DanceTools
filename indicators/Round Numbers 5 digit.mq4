//+------------------------------------------------------------------+
//|                                      2Extreme4U Grid Builder.mq4 |
//|                     Copyright © 2005, Siddiqi, Alejandro Galindo |
//|                                              http://elCactus.com |
//|                                                                  |
//|   + modified for Alerter by Tesla                                |
//|                                                      hapalkos    |
//|                                                      2007.03.23  |
//+------------------------------------------------------------------+

#property indicator_chart_window
extern color   exGridColor = DarkBlue;
extern int GridSpace = 50;
extern int AlertBand = 10;       // NOTE: Enter the number of pips from the gridline that you want the Alert to activate.
                                 // NOTE: Added AlertBand for use with Alerter.
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
  del_obj("RN-Grid ");
  
  // draw grid lines at init only, no need to update them every tick!
  draw_grid();

  return(0);
}
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
  del_obj("RN-Grid ");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
  // do nothing! no update needed every tick;
}

//+------------------------------------------------------------------+
int draw_grid()
//+------------------------------------------------------------------+
{
  int    counted_bars=IndicatorCounted();
  double I=0;
  double HighPrice;
  double LowPrice;
  double dMult;

  if (Digits<=3) dMult = 100/GridSpace;
  else dMult = 10000/GridSpace;

  // get highest and lowest prices on chart; exclude first few(6) bars, they might have ridiculously high/low values!
  int h=Highest(NULL,0,MODE_HIGH, Bars - 6, 0);
  HighPrice = MathRound(High[h] *  dMult) +4;

  int l=Lowest(NULL,0,MODE_LOW, Bars - 6, 0);
  LowPrice = MathRound(Low[l] * dMult) -4;

//  Print("Bars:"+Bars+"Highest bar:"+h+"="+High[h]);
//  Print("Bars:"+Bars+"Lowest bar:"+l+"="+Low[l]);
//  Print(LowPrice+ " " + HighPrice +" "+(HighPrice-LowPrice));

  for(I=LowPrice;I<=HighPrice;I++) {
    string obj = "RN-Grid "+DoubleToStr(I/dMult,4);
    if (ObjectFind(obj) != 0) {                     
      ObjectCreate(obj, OBJ_HLINE, 0, Time[1], I/dMult);
      ObjectSet(obj, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(obj, OBJPROP_COLOR,   exGridColor);
      string gridnamedesc = "";
      ObjectSetText(obj,gridnamedesc,10,"Arial",Black);
      ObjectSet(obj,OBJPROP_BACK, true);// for use with Tesla's Alerter indicator.
    }
  }

  return(0);
}

//+------------------------------------------------------------------+
void del_obj (string prefix)
//+------------------------------------------------------------------+
{
  string ObjName;
  int ObjTotal = ObjectsTotal();
  for(int i = ObjTotal-1; i>=0; i--) {
    ObjName = ObjectName(i);
    if(StringFind(ObjName,prefix,0)!=-1) ObjectDelete(ObjName);
  }
  return(0);
}/*del_obj*/

//end

