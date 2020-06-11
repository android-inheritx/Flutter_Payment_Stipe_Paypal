import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_stripe_payments/constants/constant.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;

  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret = 'SECRET_COME_HERE';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: "PUBLISHABLE_KEY_COME_HERE",
      merchantId: "Test",
      androidPayMode: 'test',
    ));
  }

  static Future<StripeTransactionResponse> payViaExistingCard(
      {String amount, String currency, CreditCard card}) async {
    try {
      BillingAddress billingAddress = BillingAddress(
          name: "hmohammed",
          city: "Chicago",
          country: "US",
          line1: "2045 W",
          line2: "Grand Ave Ste B",
          postalCode: "60007",
          state: "IL");

      PaymentMethodRequest paymentMethodRequest = PaymentMethodRequest(
        billingAddress: billingAddress,
        card: card,
      );

//      var paymentMethod = await StripePayment.createPaymentMethod(
//          PaymentMethodRequest(billingAddress: billingAddress, card: card));
      var paymentMethod =
          await StripePayment.createPaymentMethod(paymentMethodRequest);
      var paymentIntent = await StripeService.createPaymentIntent(
          amount, currency, paymentMethod,
          card: card);

      BillingDetails billingDetails = BillingDetails(
        address: billingAddress,
        email: "hmohammed.alesaw@sns.moe",
        name: "hmohammed",
        phone: "9898989898",
      );

      PaymentMethod paymentMethodToPass = PaymentMethod(
          billingDetails: billingDetails,
          card: card,
          created: paymentMethod.created,
          id: paymentMethod.id,
          customerId: paymentMethod.customerId,
          livemode: false,
          type: 'card');

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
        paymentMethod: paymentMethodRequest,
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent = await StripeService.createPaymentIntent(
          amount, currency, paymentMethod);

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id));
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
            message: 'Transaction successful', success: true);
      } else {
        return new StripeTransactionResponse(
            message: 'Transaction failed', success: false);
      }
    } on PlatformException catch (err) {
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency, PaymentMethod paymentMethod,
      {CreditCard card}) async {
    try {
      Map<String, dynamic> address = {
        "city": "Chicago",
        "country": "US",
        "line1": "2045 W",
        "line2": "Grand Ave Ste B",
        "postal_code": "60612-1577",
        "state": "IL"
      };

      Map<String, dynamic> billing_details = {
        "address": address,
        "email": "hmohammed.alesaw@sns.moe",
        "name": "hmohammed",
        "phone": "9898989898"
      };

      Map<String, dynamic> paymentMethod1 = {
        "id": "pk_test_yB0eiUjE1ynZIpPJe9vuqOUj001vSoUBGL",
        "object": "payment_method",
        "billing_details": billing_details
      };

      String jObjPaymentMethod = json.encode(paymentMethod1);

      Map<String, dynamic> address1 = {
        "city": "Chicago",
        "country": "US",
        "line1": "2045 W",
        "postal_code": "60612-1577",
        "state": "IL"
      };

      var jObjAddress = json.encode(address1);

      Map<String, dynamic> shipping = {
        "name": "hmohammed",
        "address": json.encode(address1),
      };

      var jObjshipping = json.encode(shipping);

      BillingAddress1 billingAddress = BillingAddress1(
        //  name: "hmohammed",
          city: "Chicago",
          country: "US",
          line1: "2045 W",
          //line2: "Grand Ave Ste B",
          postalCode: "60612-1577",
          state: "IL");

//      BillingDetails billingDetails = BillingDetails(
//        address: billingAddress,
//        email: "hmohammed.alesaw@sns.moe",
//        name: "hmohammed",
//        phone: "9898989898",
//      );

      PaymentMethod paymentMethodToPass = PaymentMethod(
          //billingDetails: billingDetails,
          card: card,
          created: paymentMethod.created,
          id: paymentMethod.id,
          customerId: paymentMethod.customerId,
          livemode: false,
          type: 'card');

      ShippingAddress shippingAddress = ShippingAddress(
        name: "hmohammed",
        billingAddress1: billingAddress
      );


      Map<String, dynamic> body = {
        'amount': amount,
        'currency': constant.CURRENCY,
        'payment_method_types[]': 'card',
        'shipping': jObjshipping,
        //'payment_method': paymentMethodToPass,
        'customer': 'cus_HM5fi4FHCByJMY',
        'description': constant.AMOUNT,
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }
}

class BillingAddress1 {
  String city;
  String country;
  String line1;
  //String line2;
  //String name;
  String postalCode;
  String state;

  BillingAddress1(
      {this.city,
      this.country,
      this.line1,
      //this.line2,
      //this.name,
      this.postalCode,
      this.state});

  factory BillingAddress1.fromJson(Map<dynamic, dynamic> json) {
    return BillingAddress1(
      city: json['city'],
      country: json['country'],
      line1: json['line1'],
      //line2: json['line2'],
     // name: json['name'],
      postalCode: json['postalCode'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.city != null) data['city'] = this.city;
    if (this.country != null) data['country'] = this.country;
    if (this.line1 != null) data['line1'] = this.line1;
   // if (this.line2 != null) data['line2'] = this.line2;
    //if (this.name != null) data['name'] = this.name;
    if (this.postalCode != null) data['postalCode'] = this.postalCode;
    if (this.state != null) data['state'] = this.state;
    return data;
  }
}

class ShippingAddress {
  String name;
  BillingAddress1 billingAddress1;

  ShippingAddress({this.name, this.billingAddress1});
}
