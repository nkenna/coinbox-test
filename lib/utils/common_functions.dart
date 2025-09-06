import 'package:coin_box_test/rate.dart';
import 'package:coin_box_test/theming/app_theme.dart';
import 'package:coin_box_test/utils/app_logger.dart';
import 'package:flutter/material.dart';

List<DropdownMenuItem<String>> populateDropDownItems({@required Rate? rate}) {
  try{
    return rate!.conversionRates!.entries.map((entry) {
      return DropdownMenuItem<String>(
        key: ValueKey(
          entry.key,
        ),
        value: entry.key,
        child: Text(entry.key, style: AppTheme.appMediumTextStyle,),
      );
    }).toList();
  }
  catch(e){
    AppLogger.instance.logError(e);
    return [];
  }

}

String? getValidCurrencyCodeForValue({List<DropdownMenuItem<String>>? itemsList, String? selectedCurrencyCode }){
  try{
    String? selectedCode =  selectedCurrencyCode != null &&
        itemsList!.any((item) => item.value == selectedCurrencyCode)
        ? selectedCurrencyCode
        : null;

    if(selectedCode == null && itemsList!.isNotEmpty){
      selectedCode = itemsList.first.value;
    }

    return selectedCode;
  }
  catch(e){
    AppLogger.instance.logError(e);
    return null;
  }
}