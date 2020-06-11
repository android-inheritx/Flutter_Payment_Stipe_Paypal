import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_payments/constants/constant.dart';
import 'package:flutter_stripe_payments/pages/paypal/PaypalPayment.dart';
import 'package:flutter_stripe_payments/utils/input_validator.dart';

class CheckOutPage extends StatefulWidget {
  CheckOutPage({Key key}) : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String dropdownValue = 'USD';
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Checkout'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _name,
                  validator: (value) => InputValidator.validateText(value),
                    decoration: InputDecoration(hintText: 'Enter name')),
                SizedBox(height: 20),
                TextFormField(
                    controller: _email,
                    validator: (value) => InputValidator.validateEmail(value),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'Enter email')),
                SizedBox(height: 20),
                TextFormField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    validator: (value) => InputValidator.validateText(value),
                    decoration: InputDecoration(hintText: 'Enter amount')),
                SizedBox(height: 30),
                Text('Select Currency'),
                SizedBox(height: 10),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['USD', 'GBP', 'INR']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 40),
                RaisedButton(
                  child: Text('Pay via stripe'),
                  onPressed: onPayStripe,
                ),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text('Pay via paypal'),
                  onPressed: onPayWithPayPal,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPayWithPayPal(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      constant.NAME = _name.text;
      constant.EMAIL = _email.text;
      constant.AMOUNT = _amount.text;
      constant.CURRENCY = dropdownValue;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalPayment(
            onFinish: (number) async {

              // payment done
              print('order id: '+number);

            },
          ),
        ),
      );
      Navigator.pushNamed(context, '/paypal-payment-page');
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void onPayStripe() {
    //to make list from object
//    List<Map<String, dynamic>> playerList = playerData.map((player) {
//      List<Map<String, dynamic>> assessment =
//          player.assessmentDataList.map((assessment) {
//        return {
//          NetworkParams.ASSESSMENT_CATEGORY_ID: assessment.categoryId,
//          NetworkParams.EVALUATION: assessment.value.toInt().toString()
//        };
//      }).toList();
//
//      return {
//        NetworkParams.PLAYER_ID: player.id,
//        NetworkParams.ASSESSMENTS: assessment
//      };
//    }).toList();

//    List<String> tempList = ["1", "2", "3"];
//    List<Map<String, dynamic>> playerList1 = tempList.map((e) {
//      return {
//        "val": e,
//      };
//    }).toList();
//
//    //To make jsonobject
//    Map<String, dynamic> billing_details = {"address": ""};
//
//    Map<String, dynamic> paymentMethod = {
//      "id": "1",
//      "billing_details": playerList1,
//      "test": billing_details
//    };
//    Map<String, dynamic> body;
//    body = {
//      "payment_method": paymentMethod,
//    };
//    String jsonObject = json.encode(body);
//    print("jsontest : " + jsonObject);
//
//    Navigator.pushNamed(context, '/home');

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      constant.EMAIL = _email.text;
      constant.AMOUNT = _amount.text;
      constant.CURRENCY = dropdownValue;
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}

class Purchase {
  int amount;
  String customerName;

  Purchase({this.amount, this.customerName});

  Map<String, dynamic> toJson() => _purchaseToJson(this);
}

Map<String, dynamic> _purchaseToJson(Purchase instance) => <String, dynamic>{
      'amount': instance.amount,
      'customerName': instance.customerName,
    };
