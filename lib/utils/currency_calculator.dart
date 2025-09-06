dynamic convertCurrency({dynamic fromRate = 1, dynamic toRate = 1, dynamic amountToConvert }){
  //return fromRate/amountToConvert  * toRate;
  num amountInBaseCurrency = amountToConvert / fromRate;
  num convertedAmount = amountInBaseCurrency * toRate;

  return convertedAmount.toStringAsFixed(4);
}