import 'package:coin_box_test/rate.dart';
import 'package:coin_box_test/service/http_service.dart';
import 'package:coin_box_test/utils/app_dio_client.dart';
import 'package:coin_box_test/utils/app_logger.dart';
import 'package:coin_box_test/utils/app_snackbar.dart';
import 'package:coin_box_test/utils/config.dart';

class RatesRepository {
  final _service = HttpService();

  Future<Rate?> getExchangeRatesRepository({String currencyCode = 'USD'}) async{
    final response = await _service.get_request(
        url: '/${Config.API_KEY}/latest/$currencyCode',
        body: {},
        options: AppDioClient.instance.getOptionsWithoutToken()
    );

    AppLogger.instance.logInfo(response);

    if (response == null) {
      return null;
    }

    int statusCode = response.statusCode;
    var payload = response.data;

    if (statusCode == 200 || statusCode == 201) {
      return Rate.fromJson(payload);
      //return payload;
    }
    else {
      showErrorBar(payload['message'] ?? 'Error occurred');
      return null;
    }
  }
}