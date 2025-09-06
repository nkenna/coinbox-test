import 'package:coin_box_test/provider/app_provider.dart';
import 'package:coin_box_test/rate.dart';
import 'package:coin_box_test/theming/app_theme.dart';
import 'package:coin_box_test/utils/app_logger.dart';
import 'package:coin_box_test/utils/common_functions.dart';
import 'package:coin_box_test/widgets/currency_divider.dart';
import 'package:coin_box_test/widgets/indicative_rate_widget.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _fromController = TextEditingController(text: '1');
  final TextEditingController _toController = TextEditingController(text: '1');

  OutlineInputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
  );

  // Calculates the converted currency amount and updates a TextEditingController.
  ///
  /// Args:
  ///   ref: The [WidgetRef] from Riverpod for accessing providers.
  ///   inputValue: The string value from the input amount TextField.
  ///   outputController: The [TextEditingController] for the TextField that displays the converted amount.
  ///   sourceCurrencyProvider: The provider holding the selected source currency (e.g., pickedCurrencyFromProvider).
  ///   targetCurrencyProvider: The provider holding the selected target currency (e.g., pickedCurrencyToProvider).
  ///   calculationProvider: The family provider used for the actual rate calculation (e.g., rateCalculatorProvider).
  ///
  /// Returns:
  ///   The calculated conversion result as a double, or null if calculation could not be performed.
  double? calculateAndSetConvertedAmount({
    required WidgetRef ref,
    required String inputValue,
    required TextEditingController outputController,
    required StateProvider<MapEntry<String, double>?> sourceCurrencyProvider,
    required StateProvider<MapEntry<String, double>?> targetCurrencyProvider,
    required StateProviderFamily<double, Map<String, dynamic>> calculationProvider,
    // Optional: Add a parameter for the 'toRate' if it's fixed in one direction of conversion
    // double? fixedTargetRate, // Example if one side has a fixed rate not from a provider
  }) {
    // 1. Read the currently selected source currency details.
    final sourceRateEntry = ref.read(sourceCurrencyProvider);

    // 2. Read the currently selected target currency details.
    final targetRateEntry = ref.read(targetCurrencyProvider);

    // 3. Guard clause: If no source currency has been selected, clear output and exit.
    if (sourceRateEntry == null) {
      outputController.clear(); // Clear the output field
      print("Debug: Source currency not selected. Cannot calculate.");
      return null; // Indicate calculation was not performed
    }

    // 4. Prepare the parameters map for the calculationProvider.
    final Map<String, dynamic> calculationParams = {
      'fromRate': sourceRateEntry.value, // Numeric rate from the source currency.
      // Use targetRateEntry.value if available, otherwise, the calculationProvider
      // or convertCurrency function needs to handle a null 'toRate' or have a default.
      // If you had a fixedTargetRate parameter, you could use it here:
      // 'toRate': fixedTargetRate ?? targetRateEntry?.value,
      'toRate': targetRateEntry?.value,
      'amountToConvert': double.tryParse(inputValue) ?? 0.0, // Parse input or default to 0.0.
    };

    // 5. Trigger the currency conversion using the calculationProvider.
    final double conversionResult = ref.read(
      calculationProvider(calculationParams),
    );

    // 6. Update the outputController's text with the calculated result.
    //    Consider formatting the result (e.g., to a specific number of decimal places).
    outputController.text = conversionResult.toStringAsFixed(2); // Example: 2 decimal places
    return conversionResult; // Return the result for potential further use
  }



  Widget currencyFromSelectField({Rate? rate, Key? key}) {
    return Consumer(
      builder: (context, ref, _) {
        final selectedCurrencyCode = ref.watch(currencyFromProvider);
        final currencyFlag = ref.watch(currencyFromFlagProvider(selectedCurrencyCode));
        final itemsList = populateDropDownItems(rate: rate);

        final String? validSelectedCurrencyCode = getValidCurrencyCodeForValue(
          itemsList: itemsList,
          selectedCurrencyCode: selectedCurrencyCode
        );

        AppLogger.instance.logInfo('Selected Currency Code: $selectedCurrencyCode');

        return SizedBox(
          key: key,
          height: 45,
          child: DropdownButtonFormField(
            icon: Icon(Icons.keyboard_arrow_down, color: Color(0xff3C3C3C)),
            style: AppTheme.appMediumTextStyle.copyWith(fontSize: 20),
            decoration: InputDecoration(
              /*hintText: 'Pick a currency',
              hintStyle: AppTheme.appRegularTextStyle.copyWith(
                color: AppTheme.titleTextColor,
              ),*/
              icon: currencyFlag != null ? flagAvatar(flag: currencyFlag) : const SizedBox.shrink(),
              border: inputBorder,
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
            ),
            value: validSelectedCurrencyCode,

            onChanged: (String? value) {
              if (value != null) {
                ref.read(currencyFromProvider.notifier).state = value;

                MapEntry? selectedEntry = rate!.conversionRates!.entries
                    .firstWhere((e) => e.key == value);

                print('Selected full entry: $selectedEntry');
                ref.read(pickedCurrencyFromProvider.notifier).state =
                    selectedEntry;

                final fromRateEntry = ref.read(
                  pickedCurrencyFromProvider,
                ); // Read once
                final toRateEntry = ref.read(
                  pickedCurrencyToProvider,
                ); // Read once

                print('From Rate Entry: $fromRateEntry');
                print('To Rate Entry: $toRateEntry');

                if (fromRateEntry == null) {
                  print(
                    "Error: 'From' currency (pickedCurrencyFromProvider) is null.",
                  );
                  // Optionally, clear any previous calculation result or show an error
                  // ref.invalidate(rateCalculatorProvider); // This would invalidate ALL instances of the family
                  // Or, if you have a specific provider for the result display:
                  // ref.read(conversionDisplayProvider.notifier).state = "Error: Pick 'from' currency";
                  return;
                }

                final Map<String, dynamic> calculationParams = {
                  'fromRate': fromRateEntry
                      .value, // Assuming .value gives the double rate
                  'toRate': toRateEntry?.value, // Your target rate
                  'amountToConvert':
                      double.tryParse(_fromController.text) ?? 0.0,
                };

                // This ensures the provider for these params computes and stores its state.
                // You can then read this state here or watch it elsewhere.
                final currentConversionResult = ref.read(
                  rateCalculatorProvider(calculationParams),
                );

                print(
                  'Current Conversion Result (from provider state): $currentConversionResult',
                );

                _toController.text = currentConversionResult.toString();
              }
            },
            items: itemsList,
          ),
        );
      },
    );
  }

  Widget currencyToSelectField({Rate? rate, Key? key}) {
    return Consumer(
      builder: (context, ref, _) {
        final selectedCurrencyCode = ref.watch(currencyToProvider);
        final currencyFlag = ref.watch(currencyToFlagProvider(selectedCurrencyCode));
        final itemsList = populateDropDownItems(rate: rate);

        final String? validSelectedCurrencyCode = getValidCurrencyCodeForValue(
            itemsList: itemsList,
            selectedCurrencyCode: selectedCurrencyCode
        );

        AppLogger.instance.logInfo('Selected Currency Code: $selectedCurrencyCode');

        return SizedBox(
          key: key,
          height: 45,
          child: DropdownButtonFormField(
            icon: Icon(Icons.keyboard_arrow_down, color: Color(0xff3C3C3C)),
            style: AppTheme.appMediumTextStyle.copyWith(fontSize: 20),
            decoration: InputDecoration(
              /*hintText: 'Pick a currency',
              hintStyle: AppTheme.appRegularTextStyle.copyWith(
                color: AppTheme.titleTextColor,
              ),*/
              icon: currencyFlag != null ? flagAvatar(flag: currencyFlag) : const SizedBox.shrink(),
              border: inputBorder,
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
            ),
            value: validSelectedCurrencyCode,
            onChanged: (String? value) {
              if (value != null) {
                ref.read(currencyToProvider.notifier).state = value;

                MapEntry? selectedEntry = rate!.conversionRates!.entries
                    .firstWhere((e) => e.key == value);

                print('Selected full entry: $selectedEntry');
                ref.read(pickedCurrencyToProvider.notifier).state =
                    selectedEntry;

                final toRateEntry = ref.read(
                  pickedCurrencyToProvider,
                ); // Read once
                final fromRateEntry = ref.read(
                  pickedCurrencyFromProvider,
                ); // Read once

                print('To Rate Entry: $toRateEntry');
                print('From Rate Entry; $fromRateEntry');

                if (toRateEntry == null) {
                  print(
                    "Error: 'From' currency (pickedCurrencyFromProvider) is null.",
                  );
                  // Optionally, clear any previous calculation result or show an error
                  // ref.invalidate(rateCalculatorProvider); // This would invalidate ALL instances of the family
                  // Or, if you have a specific provider for the result display:
                  // ref.read(conversionDisplayProvider.notifier).state = "Error: Pick 'from' currency";
                  return;
                }

                final Map<String, dynamic> calculationParams = {
                  'fromRate': toRateEntry
                      .value, // Assuming .value gives the double rate
                  'toRate': fromRateEntry?.value, // Your target rate
                  'amountToConvert': double.tryParse(_toController.text) ?? 0.0,
                };

                // This ensures the provider for these params computes and stores its state.
                // You can then read this state here or watch it elsewhere.
                final currentConversionResult = ref.read(
                  rateCalculatorProvider(calculationParams),
                );

                print(
                  'Current Conversion Result (from provider state): $currentConversionResult',
                );

                _fromController.text = currentConversionResult.toString();
              }
            },
            items: itemsList,
          ),
        );
      },
    );
  }

  Widget amountFieldContainer({
    ValueChanged<String>? onChanged,
    Key? key,
    bool editable = true,
    TextEditingController? controller,
  }) {
    return SizedBox(
      width: 141,
      height: 45,
      child: TextField(
        controller: controller,
        key: key,
        //enabled: editable,
        //readOnly: !editable,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.end,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: AppTheme.textFieldBackgroundColor,
          filled: true,
          hintText: 'Amount',
          hintStyle: AppTheme.appRegularTextStyle.copyWith(
            color: AppTheme.titleTextColor,
          ),
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
        ),
      ),
    );
  }

  Widget flagAvatar({CountryFlag? flag}){
    return CircleAvatar(
      radius: 45/2,
      child: flag,
    );
  }


  Widget formContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Consumer(
        builder: (context, ref, child) {
          final currencyState = ref.watch(currencyProvider('USD'));


          return currencyState.when(
            data: (Rate? rate) {
              return Column(
                children: [
                  // first section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: AppTheme.appRegularTextStyle.copyWith(
                          fontSize: 15,
                          color: AppTheme.titleTextColor,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: currencyFromSelectField(
                              rate: rate,
                              key: ValueKey(
                                'currency_select_field_${DateTime.now().millisecondsSinceEpoch}',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          amountFieldContainer(
                            controller: _fromController,
                            onChanged: (value) {
                              // Read the currently selected 'from' currency details from its provider.
                              final fromRateEntry = ref.read(
                                pickedCurrencyFromProvider,
                              );

                              // Read the currently selected 'to' currency details from its provider.
                              final toRateEntry = ref.read(
                                pickedCurrencyToProvider,
                              );

                              // Guard clause: If no 'from' currency has been selected yet, exit early.
                              // Conversion cannot be performed without knowing the source currency.
                              if (fromRateEntry == null) {
                                _toController.text = '0.00';
                                return;
                              };

                              // Prepare the parameters map to be passed to the rateCalculatorProvider.
                              // This map encapsulates all necessary data for the currency conversion.
                              final Map<String, dynamic> calculationParams = {
                                'fromRate': fromRateEntry.value,
                                'toRate': toRateEntry?.value,
                                'amountToConvert': double.tryParse(value) ?? 0.0,
                              };

                              final currentConversionResult = ref.read(
                                rateCalculatorProvider(calculationParams),
                              );

                              // The result is converted to a string to be displayed in the TextField.
                              _toController.text = '$currentConversionResult';
                            },
                            key: const ValueKey('amount1_input'),
                            editable: true,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  currencyDivider(),
                  const SizedBox(height: 15),

                  // second section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Converted Amount',
                        style: AppTheme.appRegularTextStyle.copyWith(
                          fontSize: 15,
                          color: AppTheme.titleTextColor,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: currencyToSelectField(
                              rate: rate,
                              key: ValueKey(
                                'currency_select_field_${DateTime.now().millisecondsSinceEpoch}',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          amountFieldContainer(
                            controller: _toController,
                            onChanged: (value) {
                              // Read the currently selected 'from' currency details from its provider.
                              final fromRateEntry = ref.read(
                                pickedCurrencyFromProvider,
                              );

                              // Read the currently selected 'to' currency details from its provider.
                              final toRateEntry = ref.read(
                                pickedCurrencyToProvider,
                              ); // Read once

                              if (toRateEntry == null) {
                                _fromController.text = '0.00';
                                return;
                              }

                              final Map<String, dynamic> calculationParams = {
                                'fromRate': toRateEntry
                                    ?.value,
                                'toRate': fromRateEntry?.value,
                                'amountToConvert':
                                double.tryParse(value) ?? 0.0,
                              };

                              // This ensures the provider for these params computes and stores its state.
                              // You can then read this state here or watch it elsewhere.
                              final currentConversionResult = ref.read(
                                rateCalculatorProvider(calculationParams),
                              );

                              print(
                                'Current Conversion Result (from provider state): $currentConversionResult',
                              );

                              _fromController.text = currentConversionResult.toString();
                            },
                            key: const ValueKey('amount2_input'),
                            editable: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
            error: (Object error, StackTrace? stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 10),
                  Text(
                    'Failed to load exchange rates.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    'Error: ${error.toString()}', // Display a user-friendly error or the error itself
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade300, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Invalidate the provider to trigger a refresh/retry
                      ref.invalidate(currencyProvider('USD'));
                    },
                    child: Text('Retry'),
                  ),
                  // You might still want to show the form structure,
                  // or just the error message as above.
                ],
              );
            },
            loading: () {
              return Center(child: CircularProgressIndicator());
            },
          );

          return Column(children: []);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).viewPadding.top),
              Text(
                'Currency Converter',
                style: AppTheme.appBoldTextStyle.copyWith(fontSize: 25),
              ),

              const SizedBox(height: 10),

              Text(
                'Check live rates, set rate alerts, receive notifications and more.',
                textAlign: TextAlign.center,
                style: AppTheme.appRegularTextStyle.copyWith(
                  fontSize: 16,
                  color: AppTheme.subTextColor,
                ),
              ),

              const SizedBox(height: 41),
              formContainer(),
              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Indicative Exchange Rate',
                  style: AppTheme.appRegularTextStyle.copyWith(
                    fontSize: 16,
                    color: Color(0xff9B9B9B),
                  ),
                ),
              ),


              IndicativeRateWidget()
            ],
          ),
        ),
      ),
    );
  }
}
