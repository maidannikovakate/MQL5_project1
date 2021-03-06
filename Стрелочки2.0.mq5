//+------------------------------------------------------------------+
//|                                                       Arrows.mq5 |
//|                                                        Srudiomay |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Studiomay"
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
CTrade trade;
input double lot = 0.3;
input int    SL  = 50;
input int    TP  = 150;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   int total;
   total = PositionsTotal();
   if(total>=1)
     {
      return;
     }

   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   MqlRates PriceInfo []; //создание массива для данных цен
   ArraySetAsSeries(PriceInfo, true); //отсортировать массив справа налево

   int Data = CopyRates(Symbol(), Period(), 0, Bars(Symbol(), Period()), PriceInfo);
   int NumberOfCandles = Bars(Symbol(), Period());
   string NumberOfCandlesText = IntegerToString(NumberOfCandles);

   if((PriceInfo[4].open<PriceInfo[4].close)
      &&((PriceInfo[3].open<PriceInfo[3].close)&&(PriceInfo[3].close>PriceInfo[4].close))
      &&(PriceInfo[2].open>PriceInfo[2].close)
      &&(((PriceInfo[2].high)-(PriceInfo[2].low))<((PriceInfo[3].high)-(PriceInfo[3].low)))
      &&(PriceInfo[1].open<PriceInfo[1].close)
      &&(PriceInfo[1].high>PriceInfo[2].high))
     {
      ObjectCreate(_Symbol, NumberOfCandlesText, OBJ_ARROW_BUY, 0, TimeCurrent(), (PriceInfo[0].low));
      Print("Поступил сигнал на покупку");
      trade.Buy(lot, NULL, Ask, (Ask-SL*_Point),(Ask+TP*_Point), NULL);
     }

   if((PriceInfo[4].open>PriceInfo[4].close)
      &&((PriceInfo[3].open>PriceInfo[3].close)&&(PriceInfo[3].close<PriceInfo[4].close))
      &&(PriceInfo[2].open<PriceInfo[2].close)
      &&(((PriceInfo[2].high)-(PriceInfo[2].low))<((PriceInfo[3].high)-(PriceInfo[3].low)))
      &&(PriceInfo[1].open>PriceInfo[1].close)
      &&(PriceInfo[1].low<PriceInfo[2].low))
     {
      ObjectCreate(_Symbol, NumberOfCandlesText, OBJ_ARROW_SELL, 0, TimeCurrent(), (PriceInfo[0].high));
      Print("Поступил сигнал на продажу");
      trade.Sell(lot, NULL, Bid, (Bid+SL*_Point),(Bid-TP*_Point), NULL);
     }
  }

//+------------------------------------------------------------------+
