import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe_payments/custom_widgets/dialogs.dart';
import 'package:flutter_stripe_payments/model/payment_charge_model.dart';
import 'package:flutter_stripe_payments/model/payment_error_model.dart';
import 'package:flutter_stripe_payments/utils/strings.dart';

import 'api_listener.dart';
import 'network_constants.dart';
import 'network_provider.dart';

class WebServices {
  ApiListener mApiListener;
  BuildContext context;

  ///--------( CONSTRUCTOR INITIALISATION )---------
  WebServices(this.context, this.mApiListener);

  ///--------( API RESPONSE PARSING )---------
  void _onApiResponse(String apiStatusCode, String apiStatus, dynamic apiData) {
    // API SUCCESS
    if (apiStatus == NetworkResponse.SUCCESS) {
      mApiListener.onApiSuccess(apiStatusCode, apiData);
      print("API SUCCESS : " + apiData.toString());
    }

    // API FAILURE
    else if (apiStatus == NetworkResponse.FAILURE) {
      mApiListener.onApiFailure(apiStatusCode, Strings.SOMETHING_WENT_WRONG);
//      final failureData = CommonModel.fromJson(json.decode(apiData));
//      if (apiStatusCode == "401") {
//        mApiListener.onApiFailure(apiStatusCode, failureData.message);
//
//        PreferenceManager.instance.clearAll();
//        print("API FAILURE : " + apiData);
//      } else {
//        mApiListener.onApiFailure(apiStatusCode, failureData.message);
//        print("API FAILURE : " + apiData);
//      }
    }

    // API EXCEPTION
    else if (apiStatus == NetworkResponse.EXCEPTION) {
      mApiListener.onException();
      Dialogs.showInfoDialog(context, Strings.SOMETHING_WENT_WRONG);
      print("API EXCEPTION : " + apiData);
    }

    // API NO_INTERNET
    else if (apiStatus == NetworkResponse.NO_INTERNET) {
      mApiListener.onNoInternetConnection();
      print("API NO_INTERNET : " + apiData);
    }
  }

  ///--------( CALL LOGIN API )---------
  void callapiPaymentCharge(String tokenId, String email, String amount, String currency) async {
    // API PARAMETERS
    final Map<String, String> param = {
      NetworkParams.STRIPE_TOKEN: tokenId,
      NetworkParams.STRIPE_EMAIL: email,
      NetworkParams.STRIPE_AMOUNT: amount,
      NetworkParams.STRIPE_CURRENCY: currency.toLowerCase(),
    };

    // API CALLING
    final mapNetworkApiStatus = await NetworkProvider.instance
        .requestMultipart(url: NetworkAPI.APP_CHARGE, body: param, method: HttpMethod.POST);

    // API RESPONSE
    var apiStatusCode = mapNetworkApiStatus[NetworkResponse.STATUS_CODE];
    var apiStatus = mapNetworkApiStatus[NetworkResponse.STATUS];
    var apiData = mapNetworkApiStatus[NetworkResponse.DATA];

    // API PARSING
    if (apiStatus == NetworkResponse.SUCCESS) {
      if (apiStatusCode == "204") {
        mApiListener.onApiFailure(
            apiStatusCode, Strings.SOMETHING_WENT_WRONG);
      } else {
        if(apiData.toString().contains("error_code")){
          apiData = PaymentErrorModel.fromJson(json.decode(apiData));
        }else {
          apiData = PaymentChargeModel.fromJson(json.decode(apiData));
        }
      }
    }
    _onApiResponse(apiStatusCode, apiStatus, apiData);
  }

}
