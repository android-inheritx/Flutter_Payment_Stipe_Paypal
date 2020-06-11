import 'package:base_scaffold/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_stripe_payments/constants/constant.dart';
import 'package:flutter_stripe_payments/custom_widgets/dialogs.dart';
import 'package:flutter_stripe_payments/data/network/api_listener.dart';
import 'package:flutter_stripe_payments/data/network/web_services.dart';
import 'package:flutter_stripe_payments/model/payment_charge_model.dart';
import 'package:flutter_stripe_payments/model/payment_error_model.dart';
import 'package:flutter_stripe_payments/services/payment-service.dart';
import 'package:flutter_stripe_payments/utils/strings.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCardsPage extends StatefulWidget {
  ExistingCardsPage({Key key}) : super(key: key);

  @override
  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> implements ApiListener{
  bool showLoader = false;

  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'Test',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555555554444',
      'expiryDate': '04/23',
      'cardHolderName': 'Tracer',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "STRIPE_PUBLISHABLE_KEY_COME_HERE",
        merchantId: "test",
        androidPayMode: 'test'));
  }

  payViaExistingCardOld(BuildContext context, card) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var expiryArr = card['expiryDate'].split('/');
    CreditCard stripeCard = CreditCard(
      number: card['cardNumber'],
      expMonth: int.parse(expiryArr[0]),
      expYear: int.parse(expiryArr[1]),
    );

    var response = await StripeService.payViaExistingCard(
        amount: '250', currency: constant.CURRENCY, card: stripeCard);
    await dialog.hide();
    Scaffold.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: 1200),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      isScreenLoadingWithBackground: showLoader,
      toolbar: AppBar(
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            var card = cards[index];
            return InkWell(
              onTap: () {
                payViaExistingCard(context, card);
                //payViaExistingCardOld(context, card);
              },
              child: CreditCardWidget(
                cardNumber: card['cardNumber'],
                expiryDate: card['expiryDate'],
                cardHolderName: card['cardHolderName'],
                cvvCode: card['cvvCode'],
                showBackView: false,
              ),
            );
          },
        ),
      ),
    );
  }

  payViaExistingCard(BuildContext context, card){
    var creditCard = convertCardForPayment(card);
    StripePayment.createTokenWithCard(
      creditCard,
    ).then((token) {
      setLoadingState(true);
      WebServices(context, this).callapiPaymentCharge(
          token.tokenId, constant.EMAIL, constant.AMOUNT, constant.CURRENCY);
      print("tokenId" + token.tokenId);
    }).catchError(setError);
  }

  CreditCard convertCardForPayment(card) {
    final CreditCard testCard = CreditCard(
      name: card['cardHolderName'],
      number: card['cardNumber'],
      cvc: card['cvvCode'],
      expMonth: 12,
      expYear: 21,
//        country: 'US',
//        addressCity: 'Kansas',
//        addressState: 'Kansas',
//        addressZip: '60007',
//        addressLine1: 'adcsafsadf',
//        addressLine2: 'dadada',
//        addressCountry: 'US'
    );
    return testCard;
  }

  void setError(dynamic error) {
    Dialogs.showInfoDialog(context, error.toString());
  }

  @override
  void onApiFailure(String statusCode, String message) {
    print("LOGIN SCREEN -> FAILURE : " + message);
    setLoadingState(false);
    Dialogs.showInfoDialog(context, message);
  }

  @override
  void onApiSuccess(String statusCode, dynamic mObject) {
    setLoadingState(false);
    if (mObject is PaymentChargeModel) {
      if(mObject.status == 'succeeded'){
        Dialogs.showInfoDialog(context, 'Payment successful', isCancelable: false, onPressed: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/amount', (Route<dynamic> route) => false);
        });
      }
    }else if(mObject is PaymentErrorModel){
      Dialogs.showInfoDialog(context, mObject.error_message, isCancelable: false, onPressed: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/amount', (Route<dynamic> route) => false);
      });
    }
  }

  @override
  void onException() {
    print("LOGIN SCREEN -> NO EXCEPTION");
    setLoadingState(false);
  }

  @override
  void onNoInternetConnection() {
    print("LOGIN SCREEN -> NO INTERNET");
    setLoadingState(false);
    Dialogs.showInfoDialog(context, Strings.ERROR_MESSAGE_NETWORK);
  }

  @override
  void setLoadingState(bool isShow) {
    setState(() {
      this.showLoader = isShow;
    });
  }
}
