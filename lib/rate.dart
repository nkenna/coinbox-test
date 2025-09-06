class Rate {
  String? result;
  String? baseCode;
  Map<String, dynamic>? conversionRates;

  Rate({this.result, this.baseCode, this.conversionRates});

  Rate.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    baseCode = json['base_code'];
    conversionRates = json['conversion_rates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['base_code'] = this.baseCode;
    if (this.conversionRates != null) {
      data['conversion_rates'] = this.conversionRates;
    }
    return data;
  }
}