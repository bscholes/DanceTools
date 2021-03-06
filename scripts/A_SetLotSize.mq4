 
#property show_inputs
 
extern double Lots              =          0.02;
extern bool   UseMoneyMgmt      =          False;
extern double RiskPercent       =          0.25;
extern double StopLoss          =          10.0;
extern int    orderMagic        =          255;
       string Input             = " Buy Price ";
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start() { 
  double Risk = RiskPercent / 100.0;
  
  double multiplier = 1.0;
  int digits = MarketInfo(Symbol(), MODE_DIGITS);
  if (digits == 5) multiplier = 10.0;
   
  double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE) * multiplier;
  Print("Tick Value: " + tickValue);
  
  if (UseMoneyMgmt) { 
   Lots = NormalizeDouble(AccountBalance() * Risk / StopLoss / tickValue, 2); 
  }
   
  if(Lots > 0) {
   GlobalVariableSet("ordersize", Lots);
   Print("Set LotSize to: " + Lots);
  }

  GlobalVariableSet("ordermagic", orderMagic);
 
   return(0);
}
