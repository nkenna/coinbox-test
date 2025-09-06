import 'package:coin_box_test/rate.dart';
import 'package:coin_box_test/repository/rates_repository.dart';
import 'package:coin_box_test/utils/app_logger.dart';
import 'package:coin_box_test/utils/currency_calculator.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ratesRepository = RatesRepository();

final currencyProvider = FutureProvider.family<Rate?, String>((
  ref,
  currencyCode,
) async {
  return ratesRepository.getExchangeRatesRepository(currencyCode: currencyCode);
});

final currencyFromProvider = StateProvider<String?>((ref) => null);
final pickedCurrencyFromProvider = StateProvider<MapEntry?>((ref) => null);
final currencyFromFlagProvider = StateProvider.family<CountryFlag, String?>((ref, currencyCode) {
  CountryFlag flag = CountryFlag.fromCurrencyCode(currencyCode ?? 'USD');
  AppLogger.instance.logInfo('flag:: ${flag}');
  return flag;
});


final currencyToProvider = StateProvider<String?>((ref) => null);
final pickedCurrencyToProvider = StateProvider<MapEntry?>((ref) => null);
final currencyToFlagProvider = StateProvider.family<CountryFlag, String?>((ref, currencyCode) {
  CountryFlag flag = CountryFlag.fromCurrencyCode(currencyCode ?? 'USD');
  AppLogger.instance.logInfo('flag:: ${flag}');
  return flag;
});

final rateCalculatorProvider = StateProvider.family<dynamic, Map<String, dynamic>>((ref, body) {
  print('body: $body');
  final result = convertCurrency(
      fromRate: body['fromRate'],
      toRate: body['toRate'],
      amountToConvert: body['amountToConvert']
  );
  print('Result: $result');
  return result;
});
