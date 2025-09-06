import 'package:coin_box_test/theming/app_theme.dart';
import 'package:coin_box_test/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/app_provider.dart';

/// A widget that displays the indicative exchange rate between two selected currencies.
///
/// This widget listens to changes in `pickedCurrencyFromProvider` and
/// `pickedCurrencyToProvider` to update the displayed rate.
class IndicativeRateWidget extends ConsumerWidget {
  const IndicativeRateWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // Watch the state of the provider that holds the selected 'from' currency.
    final pickedFromCurrency = ref.watch(pickedCurrencyFromProvider);

    // Watch the state of the provider that holds the selected 'to' currency.
    final pickedToCurrency = ref.watch(pickedCurrencyToProvider);

    // Determine the text to display based on whether both currencies have been selected.
    String displayText;
    if (pickedFromCurrency == null || pickedToCurrency == null) {
      // If either currency is not selected, display a placeholder message.
      displayText = 'Select currencies to see rate';
    } else {
      // If both currencies are selected, format the string to show the indicative rate.
      // Example: "1.0000 USD = 0.9200 EUR"
      // Using toStringAsFixed for consistent decimal representation of rates.
      displayText = '${pickedFromCurrency.value.toStringAsFixed(2)} ${pickedFromCurrency.key} = ${pickedToCurrency.value.toStringAsFixed(2)} ${pickedToCurrency.key}';
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        displayText,
        style: AppTheme.appMediumTextStyle.copyWith(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}
