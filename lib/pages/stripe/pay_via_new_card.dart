import 'dart:io';
import 'package:base_scaffold/base_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe_payments/constants/constant.dart';
import 'package:flutter_stripe_payments/custom_widgets/dialogs.dart';
import 'package:flutter_stripe_payments/data/network/api_listener.dart';
import 'package:flutter_stripe_payments/data/network/web_services.dart';
import 'package:flutter_stripe_payments/model/payment_charge_model.dart';
import 'package:flutter_stripe_payments/model/payment_error_model.dart';
import 'package:flutter_stripe_payments/utils/input_formatters.dart';
import 'package:flutter_stripe_payments/utils/payment_card.dart';
import 'package:flutter_stripe_payments/utils/strings.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PayViaNewCard extends StatefulWidget {
  @override
  _PayViaNewCardState createState() => _PayViaNewCardState();
}

class _PayViaNewCardState extends State<PayViaNewCard> implements ApiListener {
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;
  bool showLoader = false;

  var _card = new PaymentCard();

  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "STRIPE_PUBLISHABLE_KEY_COME_HERE",
        merchantId: "test",
        androidPayMode: 'test'));

    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        isScreenLoadingWithBackground: showLoader,
        toolbar: new AppBar(
          title: new Text("Pay via new card"),
        ),
        body: new Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: new ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),
                  new TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: Icon(
                        Icons.person,
                        size: 40.0,
                      ),
                      hintText: 'What name is written on card?',
                      labelText: 'Card Name',
                    ),
                    onSaved: (String value) {
                      _card.name = value;
                    },
                    keyboardType: TextInputType.text,
                    validator: (String value) =>
                        value.isEmpty ? Strings.fieldReq : null,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(19),
                      new CardNumberInputFormatter()
                    ],
                    controller: numberController,
                    decoration: new InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: CardUtils.getCardIcon(_paymentCard.type),
                      hintText: 'What number is written on card?',
                      labelText: 'Number',
                    ),
                    onSaved: (String value) {
                      print('onSaved = $value');
                      print('Num controller has = ${numberController.text}');
                      _paymentCard.number = CardUtils.getCleanedNumber(value);
                    },
                    validator: CardUtils.validateCardNum,
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: new InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: new Image.asset(
                        'assets/images/card_cvv.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      hintText: 'Number behind the card',
                      labelText: 'CVV',
                    ),
                    validator: CardUtils.validateCVV,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _paymentCard.cvv = int.parse(value);
                    },
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                      new CardMonthInputFormatter()
                    ],
                    decoration: new InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      icon: new Image.asset(
                        'assets/images/calender.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      hintText: 'MM/YY',
                      labelText: 'Expiry Date',
                    ),
                    validator: CardUtils.validateDate,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      List<int> expiryDate = CardUtils.getExpiryDate(value);
                      _paymentCard.month = expiryDate[0];
                      _paymentCard.year = expiryDate[1];
                    },
                  ),
                  new SizedBox(
                    height: 50.0,
                  ),
                  new Container(
                    alignment: Alignment.center,
                    child: _getPayButton(),
                  )
                ],
              )),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true;
      });
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      //_showInSnackBar('Payment card is valid');
      //To create payment token
      createPaymentToken();
    }
  }

  Widget _getPayButton() {
    if (Platform.isIOS) {
      return new CupertinoButton(
        onPressed: _validateInputs,
        color: CupertinoColors.activeBlue,
        child: Text(
          Strings.pay + " " + constant.AMOUNT + " " + constant.CURRENCY,
          style: TextStyle(fontSize: 17.0),
        ),
      );
    } else {
      return new RaisedButton(
        onPressed: _validateInputs,
        color: Colors.deepOrangeAccent,
        splashColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100.0)),
        ),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
        textColor: Colors.white,
        child: new Text(
          Strings.pay + " " + constant.AMOUNT + " " + constant.CURRENCY,
          style: TextStyle(fontSize: 17.0),
        ),
      );
    }
  }


  void createPaymentToken() {
    final CreditCard testCard = CreditCard(
      name: _card.name,
      number: _paymentCard.number,
      cvc: '123',
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

    StripePayment.createTokenWithCard(
      testCard,
    ).then((token) {
      setLoadingState(true);
      WebServices(context, this).callapiPaymentCharge(
          token.tokenId, constant.EMAIL, constant.AMOUNT, constant.CURRENCY);
      print("tokenId" + token.tokenId);
    }).catchError(setError);
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
