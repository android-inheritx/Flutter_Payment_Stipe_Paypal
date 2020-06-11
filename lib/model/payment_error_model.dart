class PaymentErrorModel {
    int error_code;
    String error_message;

    PaymentErrorModel({this.error_code, this.error_message});

    factory PaymentErrorModel.fromJson(Map<String, dynamic> json) {
        return PaymentErrorModel(
            error_code: json['error_code'],
            error_message: json['error_message'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['error_code'] = this.error_code;
        data['error_message'] = this.error_message;
        return data;
    }
}